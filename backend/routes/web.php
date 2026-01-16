<?php

use App\Http\Controllers\Web\Admin\AdminAuthController;
use App\Http\Controllers\Web\Admin\DashboardController;
use App\Http\Controllers\Web\Admin\UserController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::prefix('admin')->group(function () {
    Route::get('login', [AdminAuthController::class, 'showLogin'])->name('admin.login');
    Route::post('login', [AdminAuthController::class, 'login'])->name('admin.login.submit');
    Route::post('logout', [AdminAuthController::class, 'logout'])->name('admin.logout');

    Route::middleware(['auth', 'role:admin'])->group(function () {
        Route::get('/', DashboardController::class)->name('admin.dashboard');
        Route::get('users', [UserController::class, 'index'])->name('admin.users.index');
        Route::get('users/{user}', [UserController::class, 'show'])->name('admin.users.show');
    });

    Route::middleware(['auth', 'role:manager'])->group(function () {
        Route::post('users/{user}/role', [UserController::class, 'updateRole'])->name('admin.users.updateRole');
    });
});
