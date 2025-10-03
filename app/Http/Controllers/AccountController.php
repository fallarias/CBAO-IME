<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\User;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Redirect;
use Inertia\Inertia;

class AccountController extends Controller
{
    // display list of account
    public function display()
    {
        // ✅ Check if user is not an admin
        if (Auth::user()->role !== 'Admin') {
            return Redirect::route('dashboard');
        }

        
        // Get list of campuses for dropdown or reference
        $campuses = Campus::select('id', 'campus')->get();

        $users = User::with(['campus:id,campus', 'updatedBy:id,first_name,last_name,middle_name'])
        ->where('role', 'User')
        ->select([
            'id',
            'campus_id',
            'last_name',
            'first_name',
            'middle_name',
            'sex',
            'email',
            'designation',
            'campus_id',
            'reports',
            'enterprises',
            'inventory',
            'income',
            'expenses',
            'created_at',
            'updated_at',
            'updated_by',
            'account_status',
        ])
        ->get();

        // ✅ Count totals before mapping
        $total_male = $users->where('sex', 'Male')->count();
        $total_female = $users->where('sex', 'Female')->count();

        $clients = $users->map(function ($user, $key) {
            return [
                'number'        => $key + 1,
                'id'            => $user->id,
                'full_name'     => $user->last_name . ', ' . $user->first_name . ' ' . $user->middle_name,
                'sex'           => $user->sex,
                'email'         => $user->email,
                'designation'   => $user->designation,
                'campus'        => $user->campus->campus ?? 'N/A',
                'campus_id'     => $user->campus_id,
                'reports'       => (bool) $user->reports,
                'enterprises'   => (bool) $user->enterprises,
                'inventory'     => (bool) $user->inventory,
                'income'        => (bool) $user->income,
                'expenses'      => (bool) $user->expenses,
                'date' => $user->created_at->eq($user->updated_at)
                    ? Carbon::parse($user->created_at)->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A')
                    : Carbon::parse($user->updated_at)->timezone('Asia/Manila')->format('Y-m-d \a\t h:i A'),
                'updated_by'    => $user->updatedBy
                    ? $user->updatedBy->first_name . ' ' . $user->updatedBy->last_name
                    : 'N/A',
                'account_status'=> $user->account_status,
            ];
        });

        $total_users = [
            'total_male'    => $total_male,
            'total_female'  => $total_female,
            'total_overall' => $total_male + $total_female,
        ];

        return Inertia::render('Users/Accounts', [
            'campuses'     => $campuses,
            'clients'      => $clients,
            'total_users'  => $total_users,
        ]);
    }

    // save or add new user account
    public function store(Request $request)
    {
        $validated = $request->validate([
            'last_name' => 'required|string|max:255',
            'first_name' => 'required|string|max:255',
            'middle_name' => 'nullable|string|max:255',
            'sex' => 'required|in:Male,Female', // adjust values as needed
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                'unique:users,email',
                'regex:/^[A-Za-z0-9._%+-]+@isu\.edu\.ph$/'
            ],
            'campus' => 'required|exists:campuses,id',
            'designation' => 'required|string|max:255',
            'reports' => 'required|boolean',
            'enterprises' => 'required|boolean',
            'inventory' => 'required|boolean',
            'income' => 'required|boolean',
            'expenses' => 'required|boolean',
        ]);

        try {
            $user = User::create([
                'last_name'     => $validated['last_name'],
                'first_name'    => $validated['first_name'],
                'middle_name'   => $validated['middle_name'],
                'sex'           => $validated['sex'],
                'email'         => $validated['email'],
                'campus_id'     => $validated['campus'],
                'designation'   => $validated['designation'],
                'reports'       => $validated['reports'],
                'enterprises'   => $validated['enterprises'],
                'inventory'     => $validated['inventory'],
                'income'        => $validated['income'],
                'expenses'      => $validated['expenses'],
                'password'      => bcrypt('@Isu143'),
                'updated_by'    => Auth::id(),
            ]);

            if ($user) {
                return redirect()->back()->with('success', 'User account created successfully.');
            } else {
                return redirect()->back()->with('error', 'Failed to create user. Please try again.');
            }
        } catch (Exception $e) {
            return redirect()->back()->with('error', 'An error occurred: ' . $e->getMessage());
        }

        // return redirect()->back()->with('success', 'User account created successfully.');
    }

    // update user account
    public function update(Request $request, $id)
    {
        $validated = $request->validate([
            'last_name' => 'required|string|max:255',
            'first_name' => 'required|string|max:255',
            'middle_name' => 'nullable|string|max:255',
            'sex' => 'required|in:Male,Female', // adjust values as needed
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                "unique:users,email,{$id}",
                'regex:/^[A-Za-z0-9._%+-]+@isu\.edu\.ph$/'
            ],
            'campus' => 'required|exists:campuses,id',
            'designation' => 'required|string|max:255',
            'reports' => 'required|boolean',
            'enterprises' => 'required|boolean',
            'inventory' => 'required|boolean',
            'income' => 'required|boolean',
            'expenses' => 'required|boolean',
        ]);

        try {
        $user = User::findOrFail($id); // ✅ Find the user by ID

        $updated = $user->update([
            'last_name'     => $validated['last_name'],
            'first_name'    => $validated['first_name'],
            'middle_name'   => $validated['middle_name'],
            'sex'           => $validated['sex'],
            'email'         => $validated['email'],
            'campus_id'     => $validated['campus'],
            'designation'   => $validated['designation'],
            'reports'       => $validated['reports'],
            'enterprises'   => $validated['enterprises'],
            'inventory'     => $validated['inventory'],
            'income'        => $validated['income'],
            'expenses'      => $validated['expenses'],
            'updated_by'    => Auth::id(),
        ]);

        if ($updated) {
            return redirect()->back()->with('success', 'User account updated successfully.');
        } else {
            return redirect()->back()->with('error', 'Failed to update user. Please try again.');
        }

    } catch (Exception $e) {
        return redirect()->back()->with('error', 'An error occurred: ' . $e->getMessage());
    }

        // return redirect()->back()->with('success', 'User account created successfully.');
    }

    // reset user password 
    public function reset ($id) {
        try {
            $user = User::findOrFail($id);

            $user->password = bcrypt('@Isu143');
            $user->save();

            return redirect()->back()->with('success', 'Password has been reset to the default.');
        } catch (Exception $e) {
            return redirect()->back()->with('error', 'An error occurred while resetting the password: ' . $e->getMessage());
        }
    }

    // deactivate user account
    public function change_status ($id) {
        try {
            $user = User::findOrFail($id);

            $user->account_status = 'Deactivated';
            $user->save();

            return redirect()->back()->with('success', 'User account has been deactivated.');
        } catch (Exception $e) {
            return redirect()->back()->with('error', 'An error occurred while deactivating this account: ' . $e->getMessage());
        }
    }
}
