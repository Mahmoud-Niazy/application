<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class AdminUserService
{
    public function list(?string $search, int $perPage = 15): LengthAwarePaginator
    {
        return User::query()
            ->when($search, function ($q) use ($search) {
                $q->where(function ($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%")
                        ->orWhere('email', 'like', "%{$search}%");
                });
            })
            ->orderByDesc('id')
            ->paginate($perPage);
    }

    public function updateRole(User $authUser, User $user, string $role): array
    {
        $allowedRoles = [User::ROLE_USER, User::ROLE_ADMIN, User::ROLE_MANAGER];

        if (! in_array($role, $allowedRoles, true)) {
            return [
                'ok' => false,
                'status' => 422,
                'message' => 'Validation error',
                'errors' => ['role' => ['Invalid role']],
            ];
        }

        if ($authUser->id === $user->id && $role !== User::ROLE_MANAGER) {
            return [
                'ok' => false,
                'status' => 422,
                'message' => 'You cannot change your own role to lose access',
                'errors' => ['role' => ['You cannot change your own role to lose access']],
            ];
        }

        $user->forceFill(['role' => $role])->save();

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'Role updated',
            'errors' => null,
        ];
    }

    public function delete(User $authUser, User $user): array
    {
        if ($authUser->id === $user->id) {
            return [
                'ok' => false,
                'status' => 422,
                'message' => 'You cannot delete your own account',
                'errors' => null,
            ];
        }

        $user->delete();

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'User deleted',
            'errors' => null,
        ];
    }
}
