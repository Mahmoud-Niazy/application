<?php

namespace App\Services;

use App\Mail\EmailVerificationOtpMail;
use App\Mail\PasswordResetOtpMail;
use App\Models\EmailVerificationCode;
use App\Models\PasswordResetCode;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;

class AuthService
{
    private const OTP_CODE = '1111';

    public function register(array $data): User
    {
        $user = User::query()->create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => $data['password'],
            'role' => User::ROLE_USER,
            'email_verified_at' => null,
        ]);

        $this->sendEmailVerificationOtp($user);

        return $user;
    }

    public function login(string $email, string $password): array
    {
        $user = User::query()->where('email', $email)->first();

        if (! $user || ! Hash::check($password, $user->password)) {
            return [
                'ok' => false,
                'status' => 401,
                'message' => 'Invalid credentials',
                'data' => null,
                'errors' => null,
            ];
        }

        if (! $user->email_verified_at) {
            return [
                'ok' => false,
                'status' => 403,
                'message' => 'Account not verified',
                'data' => ['needs_verification' => true],
                'errors' => null,
            ];
        }

        $token = $user->createToken('api')->plainTextToken;

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'Logged in',
            'data' => [
                'token' => $token,
                'user' => $user,
            ],
            'errors' => null,
        ];
    }

    public function verifyEmail(string $email, string $code): array
    {
        $user = User::query()->where('email', $email)->first();

        if (! $user) {
            return [
                'ok' => false,
                'status' => 422,
                'message' => 'Invalid email or code',
                'data' => null,
                'errors' => ['email' => ['Invalid email or code']],
            ];
        }

        $record = EmailVerificationCode::query()->where('user_id', $user->id)->first();

        if (! $record || $record->expires_at->isPast()) {
            return [
                'ok' => false,
                'status' => 422,
                'message' => 'Code expired',
                'data' => null,
                'errors' => ['code' => ['Code expired']],
            ];
        }

        if ($record->attempts >= 5) {
            return [
                'ok' => false,
                'status' => 429,
                'message' => 'Too many attempts',
                'data' => null,
                'errors' => null,
            ];
        }

        if ($code !== self::OTP_CODE) {
            $record->attempts++;
            $record->save();

            return [
                'ok' => false,
                'status' => 422,
                'message' => 'Invalid code',
                'data' => null,
                'errors' => ['code' => ['Invalid code']],
            ];
        }

        $user->forceFill(['email_verified_at' => now()])->save();
        $record->delete();

        $token = $user->createToken('api')->plainTextToken;

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'Verified',
            'data' => [
                'token' => $token,
                'user' => $user,
            ],
            'errors' => null,
        ];
    }

    public function resendVerification(string $email): array
    {
        $user = User::query()->where('email', $email)->first();

        if (! $user) {
            return [
                'ok' => true,
                'status' => 200,
                'message' => 'If the account exists, a verification code was sent',
                'data' => null,
                'errors' => null,
            ];
        }

        $record = EmailVerificationCode::query()->where('user_id', $user->id)->first();

        if ($record && $record->last_sent_at && $record->last_sent_at->gt(now()->subSeconds(60))) {
            return [
                'ok' => false,
                'status' => 429,
                'message' => 'Too many requests',
                'data' => null,
                'errors' => null,
            ];
        }

        $this->sendEmailVerificationOtp($user);

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'Verification code sent',
            'data' => null,
            'errors' => null,
        ];
    }

    public function forgotPassword(string $email): array
    {
        $user = User::query()->where('email', $email)->first();

        if ($user) {
            $record = PasswordResetCode::query()->updateOrCreate(
                ['email' => $email],
                [
                    'code_hash' => Hash::make(self::OTP_CODE),
                    'expires_at' => now()->addMinutes(10),
                    'attempts' => 0,
                    'last_sent_at' => now(),
                ]
            );

            Mail::to($email)->send(new PasswordResetOtpMail($user->name));
        }

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'If the account exists, a reset code was sent',
            'data' => null,
            'errors' => null,
        ];
    }

    public function resetPassword(string $email, string $code, string $password): array
    {
        $record = PasswordResetCode::query()->where('email', $email)->first();

        if (! $record || $record->expires_at->isPast()) {
            return [
                'ok' => false,
                'status' => 422,
                'message' => 'Invalid or expired code',
                'data' => null,
                'errors' => ['code' => ['Invalid or expired code']],
            ];
        }

        if ($record->attempts >= 5) {
            return [
                'ok' => false,
                'status' => 429,
                'message' => 'Too many attempts',
                'data' => null,
                'errors' => null,
            ];
        }

        if ($code !== self::OTP_CODE) {
            $record->attempts++;
            $record->save();

            return [
                'ok' => false,
                'status' => 422,
                'message' => 'Invalid code',
                'data' => null,
                'errors' => ['code' => ['Invalid code']],
            ];
        }

        $user = User::query()->where('email', $email)->first();

        if ($user) {
            $user->forceFill(['password' => $password])->save();
        }

        $record->delete();

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'Password updated',
            'data' => null,
            'errors' => null,
        ];
    }

    public function googleLogin(string $idToken): array
    {
        $resp = Http::get('https://oauth2.googleapis.com/tokeninfo', [
            'id_token' => $idToken,
        ]);

        if (! $resp->ok()) {
            return [
                'ok' => false,
                'status' => 401,
                'message' => 'Invalid Google token',
                'data' => null,
                'errors' => null,
            ];
        }

        $payload = $resp->json();
        $aud = $payload['aud'] ?? null;
        $email = $payload['email'] ?? null;
        $name = $payload['name'] ?? null;

        $clientId = config('services.google.client_id');
        if ($clientId && $aud !== $clientId) {
            return [
                'ok' => false,
                'status' => 401,
                'message' => 'Invalid Google token audience',
                'data' => null,
                'errors' => null,
            ];
        }

        if (! $email) {
            return [
                'ok' => false,
                'status' => 401,
                'message' => 'Invalid Google token',
                'data' => null,
                'errors' => null,
            ];
        }

        $user = User::query()->firstOrCreate(
            ['email' => $email],
            [
                'name' => $name ?: 'Google User',
                'password' => Hash::make(Str::random(40)),
                'role' => User::ROLE_USER,
                'email_verified_at' => now(),
            ]
        );

        if (! $user->email_verified_at) {
            $user->forceFill(['email_verified_at' => now()])->save();
        }

        $token = $user->createToken('api')->plainTextToken;

        return [
            'ok' => true,
            'status' => 200,
            'message' => 'Logged in',
            'data' => [
                'token' => $token,
                'user' => $user,
            ],
            'errors' => null,
        ];
    }

    private function sendEmailVerificationOtp(User $user): void
    {
        EmailVerificationCode::query()->updateOrCreate(
            ['user_id' => $user->id],
            [
                'code_hash' => Hash::make(self::OTP_CODE),
                'expires_at' => now()->addMinutes(10),
                'attempts' => 0,
                'last_sent_at' => now(),
            ]
        );

        Mail::to($user->email)->send(new EmailVerificationOtpMail($user->name));
    }
}
