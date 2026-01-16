<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\ForgotPasswordRequest;
use App\Http\Requests\Auth\GoogleLoginRequest;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterRequest;
use App\Http\Requests\Auth\ResendVerificationRequest;
use App\Http\Requests\Auth\ResetPasswordRequest;
use App\Http\Requests\Auth\VerifyEmailRequest;
use App\Http\Resources\UserResource;
use App\Services\AuthService;
use App\Support\ApiResponse;

class AuthController extends Controller
{
    public function __construct(private readonly AuthService $authService)
    {
    }

    public function register(RegisterRequest $request)
    {
        $user = $this->authService->register($request->validated());

        return ApiResponse::success('Registered successfully', new UserResource($user), 201);
    }

    public function login(LoginRequest $request)
    {
        $result = $this->authService->login($request->validated()['email'], $request->validated()['password']);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status'], $result['data']);
        }

        return ApiResponse::success($result['message'], [
            'token' => $result['data']['token'],
            'user' => new UserResource($result['data']['user']),
        ], $result['status']);
    }

    public function verify(VerifyEmailRequest $request)
    {
        $result = $this->authService->verifyEmail($request->validated()['email'], $request->validated()['code']);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status'], $result['data']);
        }

        return ApiResponse::success($result['message'], [
            'token' => $result['data']['token'],
            'user' => new UserResource($result['data']['user']),
        ], $result['status']);
    }

    public function resendVerification(ResendVerificationRequest $request)
    {
        $result = $this->authService->resendVerification($request->validated()['email']);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status'], $result['data']);
        }

        return ApiResponse::success($result['message'], $result['data'], $result['status']);
    }

    public function forgotPassword(ForgotPasswordRequest $request)
    {
        $result = $this->authService->forgotPassword($request->validated()['email']);

        return ApiResponse::success($result['message'], $result['data'], $result['status']);
    }

    public function resetPassword(ResetPasswordRequest $request)
    {
        $data = $request->validated();

        $result = $this->authService->resetPassword($data['email'], $data['code'], $data['password']);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status'], $result['data']);
        }

        return ApiResponse::success($result['message'], $result['data'], $result['status']);
    }

    public function googleLogin(GoogleLoginRequest $request)
    {
        $result = $this->authService->googleLogin($request->validated()['id_token']);

        if (! $result['ok']) {
            return ApiResponse::error($result['message'], $result['errors'], $result['status'], $result['data']);
        }

        return ApiResponse::success($result['message'], [
            'token' => $result['data']['token'],
            'user' => new UserResource($result['data']['user']),
        ], $result['status']);
    }
}
