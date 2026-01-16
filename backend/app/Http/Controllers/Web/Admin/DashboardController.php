<?php

namespace App\Http\Controllers\Web\Admin;

use App\Http\Controllers\Controller;
use App\Services\ManagerReportService;

class DashboardController extends Controller
{
    public function __construct(private readonly ManagerReportService $managerReportService)
    {
    }

    public function __invoke()
    {
        $stats = $this->managerReportService->stats();

        return view('admin.dashboard', [
            'stats' => $stats,
        ]);
    }
}
