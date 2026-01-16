<?php

namespace App\Http\Controllers\Api\Manager;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\ManagerReportService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;

class ManagerReportController extends Controller
{
    public function __construct(private readonly ManagerReportService $managerReportService)
    {
    }

    public function __invoke(Request $request)
    {
        if (! $request->user()?->hasRole(User::ROLE_MANAGER)) {
            return ApiResponse::error('Forbidden', null, 403);
        }

        return ApiResponse::success('OK', $this->managerReportService->stats());
    }
}
