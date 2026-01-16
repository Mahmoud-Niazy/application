<?php

namespace App\Http\Controllers\Api\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\UpdateUserRoleRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use App\Services\AdminUserService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class AdminUserController extends Controller
{
    public function __construct(private readonly AdminUserService $adminUserService)
    {
    }

    public function index(Request $request)
    {
        $this->authorize('viewAny', User::class);

        $paginator = $this->adminUserService->list($request->query('search'), 15);

        $items = collect($paginator->items())
            ->map(fn ($user) => (new UserResource($user))->resolve())
            ->all();

        return ApiResponse::success('OK', [
            'items' => $items,
            'pagination' => [
                'current_page' => $paginator->currentPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
                'last_page' => $paginator->lastPage(),
            ],
        ]);
    }

    public function show(User $user)
    {
        $this->authorize('view', $user);

        return ApiResponse::success('OK', new UserResource($user));
    }

    public function updateRole(UpdateUserRoleRequest $request, User $user)
    {
        $this->authorize('updateRole', $user);

        $result = $this->adminUserService->updateRole($request->user(), $user, $request->validated()['role']);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status']);
        }

        return ApiResponse::success($result['message'], new UserResource($user));
    }

    public function destroy(Request $request, User $user)
    {
        $this->authorize('delete', $user);

        $result = $this->adminUserService->delete($request->user(), $user);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status']);
        }

        return ApiResponse::success($result['message']);
    }
}
