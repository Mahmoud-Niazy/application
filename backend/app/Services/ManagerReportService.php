<?php

namespace App\Services;

use App\Models\User;

class ManagerReportService
{
    public function stats(): array
    {
        return [
            'total_users' => User::query()->count(),
            'verified_users' => User::query()->whereNotNull('email_verified_at')->count(),
            'admins_count' => User::query()->where('role', User::ROLE_ADMIN)->count(),
            'managers_count' => User::query()->where('role', User::ROLE_MANAGER)->count(),
            'created_last_7_days' => User::query()->where('created_at', '>=', now()->subDays(7))->count(),
        ];
    }
}
