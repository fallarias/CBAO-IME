<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Inertia\Middleware;
use Tighten\Ziggy\Ziggy;

class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that is loaded on the first page visit.
     *
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determine the current asset version.
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Define the props that are shared by default.
     *
     * @return array<string, mixed>
     */
    public function share(Request $request): array
    {
        return [
            ...parent::share($request),
            'auth' => [
                // 'user' => $request->user(),
                'user' => fn () => $request->user() ? [
                    'id' => $request->user()->id,
                    'campus' => [
                        'id' => $request->user()->campus_id,
                        'campus' => optional($request->user()->campus)->campus, // ✅ campus name from relationship
                    ],
                    'avatar' => $request->user()->avatar,
                    'first_name' => $request->user()->first_name,
                    'middle_name' => $request->user()->middle_name,
                    'last_name' => $request->user()->last_name,
                    'email' => $request->user()->email,
                    'designation' => $request->user()->designation,
                    'role' => $request->user()->role,
                    'sex' => $request->user()->sex,
                    'permissions' => [
                        'accounts' => (bool) $request->user()->accounts,
                        'reports' => (bool) $request->user()->reports,
                        'enterprises' => (bool) $request->user()->enterprises,
                        'inventory' => (bool) $request->user()->inventory,
                        'income' => (bool) $request->user()->income,
                        'expenses' => (bool) $request->user()->expenses,
                        'proposals' => (bool) $request->user()->proposals,
                    ]
                ] : null,

            ],
            'ziggy' => fn () => [
                ...(new Ziggy)->toArray(),
                'location' => $request->url(),
            ],
            'flash' => [
                'success' => fn () => $request->session()->get('success'),
                'error'   => fn () => $request->session()->get('error'),
                'info'    => fn () => $request->session()->get('info'),
                'warning' => fn () => $request->session()->get('warning'),
            ],
        ];
    }
}
