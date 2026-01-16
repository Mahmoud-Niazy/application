<?php

use App\Http\Controllers\Api\Admin\AdminUserController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\Manager\ManagerReportController;
use App\Http\Controllers\Api\MeController;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('verify', [AuthController::class, 'verify']);
    Route::post('resend-verification', [AuthController::class, 'resendVerification'])->middleware('throttle:1,1');
    Route::post('forgot-password', [AuthController::class, 'forgotPassword'])->middleware('throttle:1,1');
    Route::post('reset-password', [AuthController::class, 'resetPassword']);
    Route::post('google', [AuthController::class, 'googleLogin']);
});

Route::middleware('auth:sanctum')->group(function () {
    Route::get('me', MeController::class);

    Route::prefix('admin')->middleware('role:admin')->group(function () {
        Route::get('users', [AdminUserController::class, 'index']);
        Route::get('users/{user}', [AdminUserController::class, 'show']);
    });

    Route::prefix('admin')->middleware('role:manager')->group(function () {
        Route::patch('users/{user}/role', [AdminUserController::class, 'updateRole']);
        Route::delete('users/{user}', [AdminUserController::class, 'destroy']);
    });

    Route::prefix('manager')->middleware('role:manager')->group(function () {
        Route::get('reports', ManagerReportController::class);
    });
});
