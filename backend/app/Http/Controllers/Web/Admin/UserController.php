<?php

namespace App\Http\Controllers\Web\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\AdminUserService;
use Illuminate\Http\Request;

class UserController extends Controller
{
    public function __construct(private readonly AdminUserService $adminUserService)
    {
    }

    public function index(Request $request)
    {
        $this->authorize('viewAny', User::class);

        $paginator = $this->adminUserService->list($request->query('search'), 15);

        return view('admin.users.index', [
            'users' => $paginator,
            'search' => $request->query('search'),
        ]);
    }

    public function show(User $user)
    {
        $this->authorize('view', $user);

        return view('admin.users.show', [
            'user' => $user,
        ]);
    }

    public function updateRole(Request $request, User $user)
    {
        $this->authorize('updateRole', $user);

        $data = $request->validate([
            'role' => ['required', 'in:user,admin,manager'],
        ]);

        $result = $this->adminUserService->updateRole($request->user(), $user, $data['role']);

        if (! $result['ok']) {
            return back()->withErrors($result['errors'] ?? ['role' => $result['message']]);
        }

        return redirect()->route('admin.users.show', $user);
    }
}
