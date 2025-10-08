<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\LoginRequest;
use App\Models\UserLogs;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;
use Inertia\Response;

class AuthenticatedSessionController extends Controller
{
    /**
     * Display the login view.
     */
    public function create(): Response
    {
        return Inertia::render('Auth/Login', [
            'canResetPassword' => Route::has('password.request'),
            'status' => session('status'),
        ]);
    }

    /**
     * Handle an incoming authentication request.
     */
    public function store(LoginRequest $request): RedirectResponse
    {
        $request->authenticate();

        $request->session()->regenerate();

        UserLogs::create([
            'user_id' => Auth::user()->id,
            'action' => 'Login',
            'description'=> 'User ' . Auth::user()->first_name . ' ' . Auth::user()->last_name . ' logged in to the system.',
        ]); 

        return redirect()->intended(route('dashboard', absolute: false));
    }

    /**
     * Destroy an authenticated session.
     */
    public function destroy(Request $request): RedirectResponse
    {
        UserLogs::create([
            'user_id' => Auth::user() ? Auth::user()->id : null,
            'action' => 'Logout',
            'description'=> 'User ' . (Auth::user() ? Auth::user()->first_name . ' ' . Auth::user()->last_name : 'Unknown User') . ' logged out of the system.',
        ]);
        
        Auth::guard('web')->logout();

        $request->session()->invalidate();

        $request->session()->regenerateToken();


        return redirect('/');
    }
}
