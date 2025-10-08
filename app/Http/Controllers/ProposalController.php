<?php

namespace App\Http\Controllers;

use App\Models\Campus;
use App\Models\Proposal;
use App\Models\UserLogs;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Inertia\Inertia;
use Illuminate\Support\Str;

class ProposalController extends Controller
{
    // display list of proposals
    public function display()
    {
        $user = Auth::user();
        $campuses = Campus::select('id', 'campus')->get();

        // Base query, eager load relationships
        $query = Proposal::with([
            'campus',
            'user',
            'remarks.user', // eager load remarks with user
        ])->orderBy('created_at', 'desc');

        if ($user->role !== 'Admin') {
            $query->where('user_id', $user->id);
        }

        $proposals = $query->get()->map(function ($proposal, $index) {
            return [
                'number' => $index + 1,
                'proposal_id' => $proposal->id,
                'project_title' => strtoupper($proposal->proposal_title),

                'project_file' => [
                    'title' => Str::of($proposal->proposal_title)
                        ->lower()
                        ->replace(' ', '_') . '.pdf',
                    'path'  => route('proposals.secure-view', basename($proposal->proposal_file)),
                ],

                'proposal_category' => $proposal->proposal_category,

                'campus' => $proposal->campus ? $proposal->campus->campus : null,
                'campus_id' => $proposal->campus_id,

                'submitted_by' => [
                    'name' => $proposal->user
                        ? $proposal->user->first_name . ' ' . $proposal->user->last_name
                        : null,
                    'datetime' => $proposal->created_at->format('Y-m-d \a\t h:i A'),
                ],

                'proposal_status' => $proposal->status,

                // New part: remarks
                'remarks' => $proposal->remarks()
                    ->orderBy('created_at', 'asc')
                    ->get()
                    ->map(function ($remark) {
                        return [
                            'remark' => $remark->remark,
                            'remarked_by' => $remark->user
                                ? $remark->user->first_name . ' ' . $remark->user->last_name
                                : null,
                            'remarked_by_avatar' => $remark->user
                                ? $remark->user->avatar
                                : null,
                            'remark_date' => $remark->created_at->format('M. j, Y h:i A'),
                        ];
                    })
                    ->toArray(),

                    'evaluated_by' => [
                        'name' => $proposal->evaluator
                            ? $proposal->evaluator->first_name . ' ' . $proposal->evaluator->last_name
                            : null,
                        'datetime' => $proposal->evaluated_at
                            ? $proposal->evaluated_at->format('Y-m-d \a\t h:i A')
                            : null,
                        
                    ],
            ];
        });

        return Inertia::render('Proposal/ListOfProposals', [
            'proposals' => $proposals,
            'campuses' => $campuses,
        ]);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'proposal_title'  => 'required|string|max:255',
            'proposal_file'   => 'required|file|mimes:pdf|max:10240', // PDF only, max 10MB
            'proposal_category' => 'required|string|max:100',
        ]);

        try {
            // Generate custom filename
            $dateTime = now()->format('Y-m-d_His'); // 2025-09-30_134512
            $originalName = pathinfo($request->file('proposal_file')->getClientOriginalName(), PATHINFO_FILENAME);
            $extension = $request->file('proposal_file')->getClientOriginalExtension();

            // Clean original name to avoid spaces & special chars
            $originalName = Str::slug($originalName);

            // Final filename format: YYYY-MM-DD_HHMMSS_originalfilename.pdf
            $filename = $dateTime . '_' . strtoupper($originalName) . '.' . $extension;

            // Store uploaded file in storage/app/proposals
            $path = $request->file('proposal_file')->storeAs('proposals', $filename);

            $campus = "";
            if ($request->campus_id) {
                $campus = $request->campus_id;
            } else {
                $campus = Auth::user()->campus_id;
            }

            // Save proposal record
            $proposal = Proposal::create([
                'campus_id'      => $campus,
                'user_id'        => Auth::user()->id,
                'proposal_title' => $validated['proposal_title'],
                'proposal_file'  => $path, // only store the relative path
                'proposal_category' => $validated['proposal_category'],
            ]);

            return redirect()
            ->route('proposal.display')
            ->with('success', 'Proposal submitted successfully.');

        } catch (\Exception $e) {
            return redirect()
                ->route('proposal.display')
                ->with('error', 'Failed to submit proposal. Please try again.');
        }
    }

    public function add_remark(Request $request, $id)
    {
        $validated = $request->validate([
            'remark' => 'required|string|max:1000',
        ]);

        try {
            $proposal = Proposal::findOrFail($id);

            $proposal->remarks()->create([
                'proposal_id' => $proposal->id,
                'user_id' => Auth::user()->id,
                'remark'  => $validated['remark'],
            ]);

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Add Remark',
                'description' => 'Added a remark on proposal: "' . $proposal->proposal_title . '"',
            ]);

            return redirect()
                ->route('proposal.display')
                ->with('success', 'Remark added successfully.');

        } catch (\Exception $e) {
            return redirect()
                ->route('proposal.display')
                ->with('error', 'Failed to add remark. Please try again.');
        }
    }

    public function evaluate(Request $request, $id)
    {
        $validated = $request->validate([
            'action' => 'required|in:Approved,Declined',
        ]);

        try {
            $proposal = Proposal::findOrFail($id);

            $proposal->status = $validated['action'];
            $proposal->evaluated_by = Auth::user()->id;
            $proposal->evaluated_at = now();
            $proposal->save();

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Evaluate Proposal',
                'description' => $validated['action'] . ' proposal: "' . $proposal->proposal_title . '"',
            ]);

            return redirect()
                ->route('proposal.display')
                ->with('success', 'Proposal ' . strtolower($validated['action']) . ' successfully.');

        } catch (\Exception $e) {
            return redirect()
                ->route('proposal.display')
                ->with('error', 'Failed to evaluate proposal. Please try again.');
        }
    }

    public function update(Request $request, $id)
    {
        // dd($request->all());
        $validated = $request->validate([
            'proposal_title' => 'required|string|max:255',
            'proposal_file' => 'nullable|sometimes|file|mimes:pdf|max:10240', // Optional PDF upload
            'proposal_category' => 'required|string|max:100',
        ]);

        try {
            // Find the existing proposal
            $proposal = Proposal::findOrFail($id);

            // Determine campus
            $campus = $request->campus_id ?? Auth::user()->campus_id;

            // Start with the existing file path
            $path = $proposal->proposal_file;

            // ✅ Only handle file replacement if a new file is uploaded
            if ($request->hasFile('proposal_file')) {
                // Delete old file if it exists
                if ($proposal->proposal_file && Storage::exists($proposal->proposal_file)) {
                    Storage::delete($proposal->proposal_file);
                }

                // Generate new custom filename
                $dateTime = now()->format('Y-m-d_His'); // e.g., 2025-10-04_154512
                $originalName = pathinfo($request->file('proposal_file')->getClientOriginalName(), PATHINFO_FILENAME);
                $extension = $request->file('proposal_file')->getClientOriginalExtension();

                // Clean and format filename
                $originalName = Str::slug($originalName);
                $filename = $dateTime . '_' . strtoupper($originalName) . '.' . $extension;

                // Store new file and update path
                $path = $request->file('proposal_file')->storeAs('proposals', $filename);
            }

            // ✅ Update database record (keeps old file if no new upload)
            $proposal->campus_id = $request->campus_id ?? $proposal->campus_id;
            $proposal->proposal_title = $validated['proposal_title'];
            $proposal->proposal_category = $validated['proposal_category'];
            $proposal->proposal_file = $path; // retain old file if no new upload
            $proposal->save();

            UserLogs::create([
                'user_id' => Auth::user()->id,
                'action' => 'Updated Proposal',
                'description' => 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' updated the proposal: ' . $validated['proposal_title'] . '.',
            ]);

            return redirect()
                ->route('proposal.display')
                ->with('success', 'Proposal updated successfully.');

        } catch (\Exception $e) {
            return redirect()
                ->route('proposal.display')
                ->with('error', 'Failed to update proposal. Please try again.');
        }
    }
}
