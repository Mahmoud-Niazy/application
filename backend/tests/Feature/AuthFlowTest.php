<?php

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

test('register -> verify -> login works', function () {
    $email = 'newuser@example.com';

    $register = $this->postJson('/api/auth/register', [
        'name' => 'New User',
        'email' => $email,
        'password' => 'password123',
        'password_confirmation' => 'password123',
    ]);

    $register->assertStatus(201)
        ->assertJsonPath('success', true)
        ->assertJsonMissing(['1111']);

    $loginBeforeVerify = $this->postJson('/api/auth/login', [
        'email' => $email,
        'password' => 'password123',
    ]);

    $loginBeforeVerify->assertStatus(403)
        ->assertJsonPath('success', false)
        ->assertJsonPath('data.needs_verification', true);

    $verify = $this->postJson('/api/auth/verify', [
        'email' => $email,
        'code' => '1111',
    ]);

    $verify->assertStatus(200)
        ->assertJsonPath('success', true)
        ->assertJsonPath('data.user.email', $email)
        ->assertJsonPath('data.user.is_verified', true)
        ->assertJsonStructure([
            'success',
            'message',
            'data' => ['token', 'user'],
            'errors',
        ]);

    $login = $this->postJson('/api/auth/login', [
        'email' => $email,
        'password' => 'password123',
    ]);

    $login->assertStatus(200)
        ->assertJsonPath('success', true)
        ->assertJsonStructure([
            'success',
            'message',
            'data' => ['token', 'user'],
            'errors',
        ]);
});

test('forgot password -> reset password works', function () {
    $user = User::factory()->create([
        'email' => 'resetme@example.com',
        'password' => 'password123',
        'email_verified_at' => now(),
    ]);

    $forgot = $this->postJson('/api/auth/forgot-password', [
        'email' => $user->email,
    ]);

    $forgot->assertStatus(200)
        ->assertJsonPath('success', true);

    $reset = $this->postJson('/api/auth/reset-password', [
        'email' => $user->email,
        'code' => '1111',
        'password' => 'newpassword123',
        'password_confirmation' => 'newpassword123',
    ]);

    $reset->assertStatus(200)
        ->assertJsonPath('success', true);

    $login = $this->postJson('/api/auth/login', [
        'email' => $user->email,
        'password' => 'newpassword123',
    ]);

    $login->assertStatus(200)
        ->assertJsonPath('success', true);
});
