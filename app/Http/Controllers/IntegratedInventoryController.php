<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Enterprise;
use App\Models\IntegratedInventory;
use App\Models\Inventory;
use App\Models\Transaction;
use App\Models\User;
use App\Models\UserLogs;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rule;
use Inertia\Inertia;


class IntegratedInventoryController extends Controller
{
    // display list of products
    public function display()
    {
        $user = Auth::user();
        $campuses = Campus::select('id', 'campus')->get();
        $campus_id = $user->campus->id;

        // ✅ Base query with relationships
        $query = IntegratedInventory::with([
            //'enterprise:id,enterprise',
            'campus:id,campus',
            'updatedByUser:id,first_name,last_name',
        ])->orderBy('created_at', 'desc');;

        // ✅ If role is "User", filter by campus_id
        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $inventories = $query->get()->map(function ($item, $key) {
            return [
                'id' => $item->id,
                'number' => $key + 1,
                //'image' => $item->image,
                'campus' => [
                    'id' => $item->campus_id,
                    'name' => $item->campus->campus ?? 'N/A',
                ],
                'product_name' => $item->product_name,
                'category' => $item->category,
                //'enterprise_name' => $item->enterprise->enterprise ?? 'N/A',
                'quantity' => $item->quantity,
                'price' => number_format($item->price, 2),
                //'unit' => $item->unit ?? '--',
                'status' => $item->status,
                'date' => $item->created_at->eq($item->updated_at)
                    ? $item->created_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                    : $item->updated_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                'updated_by' => $item->updatedByUser
                    ? $item->updatedByUser->first_name . ' ' . $item->updatedByUser->last_name
                    : 'Unknown',
            ];
        });

        return Inertia::render('Integrated_Inventory/ProductInventory', [
            'inventories' => $inventories,
            'campuses' => $campuses,
        ]);
    }


    public function store(Request $request)
    {
        $validated = $request->validate([
            // 'enterprise_id' => ['required', 'integer', 'min:0'],
            // 'enterprise_name' => [
            //     'nullable',
            //     'string',
            //     'max:255',
            //     Rule::requiredIf($request->enterprise_id == 0),
            //     Rule::excludeIf($request->enterprise_id != 0),
            // ],

            // 'enterprise_category' => [
            //     'nullable',
            //     'string',
            //     'max:255',
            //     Rule::requiredIf($request->enterprise_id == 0),
            //     Rule::excludeIf($request->enterprise_id != 0),
            // ],
            'product_name' => ['required', 'string'],
            'quantity' => ['required', 'numeric', 'min:0'],
            //'unit' => ['required', 'string', Rule::in(['pc', 'kg', 'm', 'l'])],
            'price' => [
                'required',
                'numeric',
                'min:0',
                'regex:/^\d+(\.\d{1,2})?$/'
            ],
            'low' => [
                'required',
                'numeric',
                'min:0',
            ],
        ]);

        // Determine the enterprise_id
        // if ($validated['enterprise_id'] == 0) {
        //     // Create new enterprise
        //     $enterprise = Enterprise::create([
        //         'enterprise' => strtoupper($validated['enterprise_name']),
        //         'category' => $validated['enterprise_category'],
        //         'campus_id' => Auth::user()->campus_id, // Optional if enterprise table is campus-specific
        //     ]);

        //     $enterprise_id = $enterprise->id;
        // } else {
        //     $enterprise_id = $validated['enterprise_id'];
        // }

        // Save to inventories table
        $agri = 'Agri-based';
        $non = 'Non Agri-based';

        IntegratedInventory::create([
            'product_name' => $validated['product_name'],
            'quantity' => $validated['quantity'],
            'low' => $validated['low'],
            'price' => $validated['price'],
            'campus_id' => Auth::user()->campus_id,
            'category' => $non,
        ]);

        return redirect()->back()->with('success', 'Enterprise was successfully added to the inventory.');
    }

    // import enterprises
    public function import(Request $request)
    {
        $validated = $request->validate([
            'campus_id' => 'required|exists:campuses,id',
        ]);

        $user = Auth::user();

        try {
            // 🧾 Get all existing enterprise IDs in inventories table
            $existingInventoryEnterpriseIds = Inventory::pluck('enterprise_id')->toArray();

            // 🏢 Base query: Enterprises in the selected campus with inventory = 1 and not yet in inventories
            $query = Enterprise::select('id', 'enterprise', 'campus_id')
                ->where('campus_id', $validated['campus_id'])
                ->where('inventory', 1)
                ->whereNotIn('id', $existingInventoryEnterpriseIds);

            // 🔒 Restrict "User" role to their own campus
            if ($user->role === 'User' && $user->campus_id != $validated['campus_id']) {
                return redirect()->back()->with('error', 'Unauthorized campus selection.');
            }

            // ✅ Retrieve enterprises (alphabetically)
            $inventoryEnterprises = $query->orderBy('enterprise', 'asc')->get();

            // 🧩 If no new enterprises, return info message
            if ($inventoryEnterprises->isEmpty()) {
                return redirect()
                    ->back()
                    ->with('info', 'No new enterprises to import. All are already in the inventory.');
            }

            // 🗂️ Insert each enterprise into inventories table
            foreach ($inventoryEnterprises as $enterprise) {
                Inventory::create([
                    'campus_id' => $enterprise->campus_id,
                    'enterprise_id' => $enterprise->id,
                    'updated_by' => $user->id,
                ]);
            }

            // 🏫 Get campus name
            $campusName = Campus::where('id', $validated['campus_id'])->value('campus');

            // 🧾 Log user action
            UserLogs::create([
                'user_id' => $user->id,
                'action' => 'Imported Business Enterprises to Inventory',
                'description' => "User {$user->first_name} {$user->last_name} imported enterprises with inventories for campus {$campusName}.",
            ]);

            return redirect()->back()->with('success', 'Enterprises with inventory were successfully imported.');
        } catch (\Exception $e) {
            // \Log::error('Inventory import failed: ' . $e->getMessage());

            return redirect()
                ->back()
                ->with('error', 'Failed to import enterprises: ' . $e->getMessage());
        }
    }

    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'product_name' => ['required','string'],
            'quantity' => ['required', 'numeric', 'min:0'],
            'low' => ['required', 'numeric'],
            'price' => [
                'required',
                'numeric',
                'min:0',
                'regex:/^\d+(\.\d{1,2})?$/'
            ],
            'status' => ['required', 'string', Rule::in(['Available', 'Not Available'])],
            'category' => ['required', 'string', Rule::in(['Agri-based', 'Non Agri-based'])],
        ]);

        // dd($validated['enterprise_status']);

        try {
            $inventory = IntegratedInventory::findOrFail($id);

            $inventory->update([
                'quantity' => $validated['quantity'],
                'low' => $validated['low'],
                'price' => $validated['price'],
                'status' => $validated['status'],
                'category' => $validated['category'],
                'updated_by' => Auth::user()->id,
            ]);

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Updated Inventory Item',
                'description' => 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' updated inventory item for enterprise: ' . ($inventory->enterprise->enterprise ?? 'N/A') . '.',
            ]);

            return redirect()->back()->with('success', 'Inventory updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to update inventory: ' . $e->getMessage());
        }
    }

    // display list of products
    public function view() {
        return Inertia::render('Inventory/InventorySalesPerProduct');
    }

    //INVENTORY SALES
    //display list of sales
    public function display_sales()
    {
        $user = Auth::user();
        $campuses = Campus::select('id', 'campus')->get();
        $campus_id = $user->campus->id;

        // ✅ Base query with relationships
        $query = Transaction::with([
            //'enterprise:id,enterprise',
            'campus:id,campus',
            'product:id,product_name,price',
            //'updatedByUser:id,first_name,last_name',
        ])->orderBy('created_at', 'desc')->whereNotNull('date_paid');

        // ✅ If role is "User", filter by campus_id
        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $queryForProduct = IntegratedInventory::with([
            //'enterprise:id,enterprise',
            'campus:id,campus',
            //'product:id,product_name,price',
            //'updatedByUser:id,first_name,last_name',
        ])->orderBy('created_at', 'desc');

        $transaction = $query->get()->map(function ($item, $key) {
            return [
                'transaction_id' => $item->id,
                'number' => $key + 1,
                'campus' => [
                    'id' => $item->campus_id,
                    'name' => $item->campus->campus ?? 'N/A',
                ],
                'product' => [
                    'id' => $item->product_id,
                    'product_name' => $item->product->product_name ?? '',
                    'price' => number_format($item->product->price, 2),
                ],
                'name' => $item->name,
                'category' => $item->category,
                'quantity' => $item->quantity,
                'order' => $item->status,
                'purchased' => $item->date_purchase ? Carbon::parse($item->date_purchase)->format('F d, Y h:i A') : '',
                'paid' => $item->date_paid ? Carbon::parse($item->date_paid)->format('F d, Y h:i A') : '',
                'id_number' => $item->id_number,
                'total' => number_format($item->product->price * $item->quantity, 2),
                'date' => $item->created_at->eq($item->updated_at)
                    ? $item->created_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                    : $item->updated_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                'updated_by' => $item->updatedByUser
                    ? $item->updatedByUser->first_name . ' ' . $item->updatedByUser->last_name
                    : 'Unknown',
            ];
        });

        $products = $queryForProduct->get()->map(function ($item, $key ){
            return [
                'id' => $item->id,                     // <-- needed
                'product_name' => $item->product_name,
                'campus_id' => $item->campus_id,
                'price' => number_format($item->price, 2),
            ];
        });

        return Inertia::render('Integrated_Inventory/SalesReport', [
            'inventories' => $transaction,
            'campuses' => $campuses,
            'products' => $products
        ]);
    }

    //inertia chart for sales per product
    public function show()
        {
        $user = Auth::user();
        $campuses = Campus::select('id', 'campus')->get();
        $campus_id = $user->campus->id;

        // ✅ Base query with relationships
        $query = Transaction::with([
            //'enterprise:id,enterprise',
            //'campus:id,campus',
            'product:id,product_name,price',
            //'updatedByUser:id,first_name,last_name',
        ])->where('status','paid');

        // ✅ If role is "User", filter by campus_id
        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $transaction = $query->get()->map(function ($item, $key) {
            return [
                'transaction_id' => $item->id,
                'number' => $key + 1,
                'campus' => [
                    'id' => $item->campus_id,
                    'name' => $item->campus->campus ?? 'N/A',
                ],
                'product' => [
                    'id' => $item->product_id,
                    'product_name' => $item->product->product_name ?? '',
                    'price' => number_format($item->product->price, 2),
                ],
                'name' => $item->name,
                'category' => $item->category,
                'quantity' => $item->quantity,
                'order' => $item->status,
                'purchased' => $item->date_purchase ? Carbon::parse($item->date_purchase)->format('F d, Y h:i A') : '',
                'paid' => $item->date_paid ? Carbon::parse($item->date_paid)->format('F d, Y h:i A') : '',
                'id_number' => $item->id_number,

                // add this
                'raw_total' => ($item->product->price * $item->quantity),

                'total' => number_format($item->product->price * $item->quantity, 2),
                'date' => $item->created_at->eq($item->updated_at)
                    ? $item->created_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                    : $item->updated_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                'updated_by' => $item->updatedByUser
                    ? $item->updatedByUser->first_name . ' ' . $item->updatedByUser->last_name
                    : 'Unknown',
            ];
        });

        $labels = $transaction->pluck('product.product_name')->toArray();
        $data = $transaction->pluck('raw_total')->toArray();

        // generate dynamic colors
        $baseColors = ['#f87979','#42a5f5','#66bb6a','#ffeb3b','#ff7043','#8e24aa','#26c6da'];
        $backgroundColor = [];
        foreach ($data as $i => $val) {
            $backgroundColor[] = $baseColors[$i % count($baseColors)];
        }

        return Inertia::render('Integrated_Inventory/Partial/SalesPerProduct', [
            'sales_data' => $transaction,
            'campuses' => $campuses,
            'chartData' => [
                'labels' => $labels,
                'datasets' => [
                    [
                        'label' => 'Total Sales',
                        'backgroundColor' => $backgroundColor,
                        'data' => $data,
                    ]
                ]
            ]
        ]);
    }

    //chart for sales per product
    public function salesPerProduct()
    {
        $user = Auth::user();
        $campus_id = $user->campus->id;

        $query = Transaction::with('product:id,product_name,price')
            ->where('status', 'paid');

        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $transaction = $query->get();

        $labels = $transaction->pluck('product.product_name')->toArray();
        $data = $transaction->map(fn($item) =>
            $item->product->price * $item->quantity
        )->toArray();

        $baseColors = ['#f87979','#42a5f5','#66bb6a','#ffeb3b','#ff7043','#8e24aa','#26c6da'];
        $colors = [];

        foreach ($data as $i => $v) {
            $colors[] = $baseColors[$i % count($baseColors)];
        }

        return response()->json([
            'labels' => $labels,
            'datasets' => [
                [
                    //'label' => 'Total Sales',
                    'data' => $data,
                    'backgroundColor' => $colors,
                ]
            ]
        ]);
    }

    public function monthlySaless()
    {
        $user = Auth::user();
        $campus_id = $user->campus->id;

        $query = Transaction::with('product:id,product_name,price')
            ->where('status', 'paid');

        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $transaction = $query->get();

        $labels = $transaction->pluck('product.product_name')->toArray();
        $data = $transaction
            ->groupBy(function ($item) {
                return \Carbon\Carbon::parse($item->date_paid)->format('m');
            })
            ->map(function ($items) {
                return $items->sum(fn($item) => $item->product->price * $item->quantity);
            })
            ->toArray();


        $baseColors = ['#f87979','#42a5f5','#66bb6a','#ffeb3b','#ff7043','#8e24aa','#26c6da'];
        $colors = [];

        foreach ($data as $i => $v) {
            $colors[] = $baseColors[$i % count($baseColors)];
        }

        return response()->json([
            'labels' => $labels,
            'datasets' => [
                [
                    'label' => 'Monthly Sales',
                    'data' => $data,
                    'backgroundColor' => $colors,
                ]
            ]
        ]);
    }

    public function monthlySales()
    {
        $user = Auth::user();
        $campus_id = $user->campus->id;

        $query = Transaction::with('product:id,product_name,price')
            ->where('status', 'paid');

        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $transactions = $query->get();

        // Group by month number e.g. "01"
        $grouped = $transactions->groupBy(function ($item) {
            return \Carbon\Carbon::parse($item->date_paid)->format('m');
        });

        // Sum total sales per month
        $monthlySales = $grouped->map(function ($items) {
            return $items->sum(fn($i) => $i->product->price * $i->quantity);
        });

        return response()->json([
            'labels' => array_keys($monthlySales->toArray()),  // ["01","02","11"]
            'datasets' => [
                [
                    'label' => 'Monthly Sales',
                    'data' => array_values($monthlySales->toArray()) // [1000,2000,3000]
                ]
            ]
        ]);
    }

    //INVENTORY TRANSCTION
    //display list of transaction
    public function display_transaction()
    {
        $user = Auth::user();
        $campuses = Campus::select('id', 'campus')->get();
        $campus_id = $user->campus->id;

        // ✅ Base query with relationships
        $query = Transaction::with([
            //'enterprise:id,enterprise',
            'campus:id,campus',
            'product:id,product_name,price',
            //'updatedByUser:id,first_name,last_name',
        ])->orderBy('created_at', 'desc');

        // ✅ If role is "User", filter by campus_id
        if ($user->role === 'User') {
            $query->where('campus_id', $campus_id);
        }

        $transaction = $query->get()->map(function ($item, $key) {
            return [
                'id' => $item->id,
                'number' => $key + 1,
                'campus' => [
                    'id' => $item->campus_id,
                    'name' => $item->campus->campus ?? 'N/A',
                ],
                'product' => [
                    'id' => $item->product_id,
                    'product_name' => $item->product->product_name ?? '',
                    'price' => number_format($item->product->price * $item->quantity, 2),
                ],
                'name' => $item->name,
                'category' => $item->category,
                'quantity' => $item->quantity,
                'order' => $item->status,
                'purchase' => $item->date_purchase ? Carbon::parse($item->date_purchase)->format('F d, Y h:i A') : '',
                'paid' => $item->date_paid ? Carbon::parse($item->date_paid)->format('F d, Y h:i A') : '',
                'id_number' => $item->id_number,
                'date' => $item->created_at->eq($item->updated_at)
                    ? $item->created_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                    : $item->updated_at->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                'updated_by' => $item->updatedByUser
                    ? $item->updatedByUser->first_name . ' ' . $item->updatedByUser->last_name
                    : 'Unknown',
            ];
        });

        $products = $query->get()->map(function ($item, $key ){
            return [
                'id' => $item->id,                     // <-- needed
                'product_name' => $item->product_name,
                'campus_id' => $item->campus_id,
                'price' => number_format($item->price, 2),
            ];
        });

        $personnels = User::where('role', 'User')->get()->map(function ($user) {
            return [
                'id' => $user->id,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'designation' => $user->designation,
            ];
        });

        $reservation = IntegratedInventory::where('campus_id', $campus_id)
                                        ->where('quantity', '!=', 0)->get();

        return Inertia::render('Integrated_Inventory/TransactionList', [
            'transaction' => $transaction,
            'campuses' => $campuses,
            'products' => $products,
            'reservation' => $reservation,
            'personnels' => $personnels,
        ]);
    }

    public function transaction_store(Request $request){
        $validated = $request->validate([
            'product_id' => ['required', 'numeric'],
            'quantity' => ['required', 'numeric', 'min:1'],
            'campus' => ['required', 'string'],
            'id_number' => ['required','string'],
            'name' => ['string'],
        ]);

        // Save to inventories table
        $agri = 'Agri-based';
        $non = 'Non Agri-based';
        $category = 'Default';

        $product = IntegratedInventory::findOrFail($validated['product_id']);

        $substract = $product->quantity - $validated['quantity'];

        IntegratedInventory::where('id', $product->id)
                            ->update([
                                'quantity' => $substract,
                            ]);

        Transaction::create([
            'product_id' => $validated['product_id'],
            'name' => $validated['name'],
            'id_number' => $validated['id_number'],
            'quantity' => $validated['quantity'],
            'campus_id' => $validated['campus'],
            'status' => 'paid',
            'category' => $category,
            'date_purchase' => now()->subHours(5),
            'date_paid' => now(),
        ]);

        return redirect()->back()->with('success', 'Enterprise was successfully added to the inventory.');
    }

    public function status_update(Request $request){
        $validated = $request->validate([
            'id' => ['required','integer'],
            'status' => ['required', 'string', Rule::in(['paid', 'unpaid', 'cancelled'])],
        ]);

        // dd($validated['enterprise_status']);

        try {
            $status_update = Transaction::findOrFail($validated['id']);

            $status_update->update([
                'status' => $validated['status'],
            ]);
            if ($status_update->status === 'paid'){
                $status_update->update([
                    'date_paid' => now(),
                ]);
            }

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Updated Transcation Status',
                'description' => 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' updated transaction status for enterprise: ' . ($inventory->enterprise->enterprise ?? 'N/A') . '.',
            ]);

            return redirect()->back()->with('success', 'Status updated successfully.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Failed to update inventory: ' . $e->getMessage());
        }
    }

    public function transaction_reservation(Request $request){

        //dd($request->all());
        $validated = $request->validate([
            'product_id' => ['required', 'numeric'],
            'quantity' => ['required', 'numeric', 'min:1'],
            'campus' => ['required', 'numeric'],
        ]);

        // Save to inventories table
        $agri = 'Agri-based';
        $non = 'Non Agri-based';
        $category = 'Reserve';

        $user = User::where('id', $validated['campus'])->first();

        //dd($user);
        $product = IntegratedInventory::findOrFail($validated['product_id']);

        $substract = $product->quantity - $validated['quantity'];

        IntegratedInventory::where('id', $product->id)
                            ->update([
                                'quantity' => $substract,
                            ]);

        Transaction::create([
            'product_id' => $validated['product_id'],
            'name' => $user->first_name . ' ' . $user->last_name,
            'id_number' => '',
            'quantity' => $validated['quantity'],
            'campus_id' => $user->campus_id,
            'status' => 'paid',
            'category' => $category,
            'date_purchase' => now()->subHours(5),
            'date_paid' => now(),
        ]);

        return redirect()->back()->with('success', 'Enterprise was successfully added to the inventory.');
    }
}
