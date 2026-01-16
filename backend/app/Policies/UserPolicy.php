<?php

namespace App\Policies;

use App\Models\User;

class UserPolicy
{
    public function viewAny(User $authUser): bool
    {
        return $authUser->hasRole(User::ROLE_ADMIN);
    }

    public function view(User $authUser, User $user): bool
    {
        return $authUser->hasRole(User::ROLE_ADMIN);
    }

    public function updateRole(User $authUser, User $user): bool
    {
        return $authUser->hasRole(User::ROLE_MANAGER);
    }

    public function delete(User $authUser, User $user): bool
    {
        return $authUser->hasRole(User::ROLE_MANAGER);
    }
}
