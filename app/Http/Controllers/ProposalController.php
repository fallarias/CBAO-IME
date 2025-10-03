<?php

namespace App\Http\Controllers;

use App\Models\Proposal;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Illuminate\Support\Str;

class ProposalController extends Controller
{
    // display list of proposals
    public function display() {
        $user = Auth::user();

        // Base query
        $query = Proposal::with(['campus', 'user'])
            ->orderBy('created_at', 'desc');

        if ($user->role !== 'Admin') {
            $query->where('user_id', $user->id);
        }

        $proposals = $query->get()->map(function ($proposal, $index) {
            return [
                'number' => $index + 1,
                'project_title' => strtoupper($proposal->proposal_title),

                'project_file' => [
                    'title' => Str::of($proposal->proposal_title)
                        ->lower()
                        ->replace(' ', '_') . '.pdf',
                    'path'  => route('proposals.secure-view', basename($proposal->proposal_file)),
                ],                

                'campus' => $proposal->campus ? $proposal->campus->campus : null,

                'submitted_by' => [
                    'name' => $proposal->user
                        ? $proposal->user->first_name . ' ' . $proposal->user->last_name
                        : null,
                    'datetime' => $proposal->created_at->format('Y-m-d \a\t h:i A'),
                ],                

                'proposal_status' => $proposal->status,
            ];
        });

        return Inertia::render('Proposal/ListOfProposals', [
            'proposals' => $proposals,
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

            // Save proposal record
            $proposal = Proposal::create([
                'campus_id'      => Auth::user()->campus_id,
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

        // return redirect()
        //     ->route('proposal.display')
        //     ->with('success', 'Proposal submitted successfully.');

        // $data = ([
        //     'campus_id'      => Auth::user()->campus_id,
        //     'user_id'        => Auth::user()->id,
        //     'proposal_title' => $validated['proposal_title'],
        //     'proposal_file'  => $filename,
        //     'status'         => 'Pending',
        // ]);

        // return redirect()->back()->with($data);
        // return json_encode($data);
    }
}
