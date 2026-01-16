<?php

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

test('admin and manager can list users, normal user cannot', function () {
    $admin = User::factory()->create(['role' => User::ROLE_ADMIN, 'email_verified_at' => now()]);
    $manager = User::factory()->create(['role' => User::ROLE_MANAGER, 'email_verified_at' => now()]);
    $user = User::factory()->create(['role' => User::ROLE_USER, 'email_verified_at' => now()]);

    $adminToken = $admin->createToken('api')->plainTextToken;
    $managerToken = $manager->createToken('api')->plainTextToken;
    $userToken = $user->createToken('api')->plainTextToken;

    $this->withHeader('Authorization', 'Bearer '.$adminToken)
        ->getJson('/api/admin/users')
        ->assertStatus(200)
        ->assertJsonPath('success', true);

    $this->withHeader('Authorization', 'Bearer '.$managerToken)
        ->getJson('/api/admin/users')
        ->assertStatus(200)
        ->assertJsonPath('success', true);

    $this->withHeader('Authorization', 'Bearer '.$userToken)
        ->getJson('/api/admin/users')
        ->assertStatus(403);
});

test('only manager can change roles and cannot demote self', function () {
    $manager = User::factory()->create(['role' => User::ROLE_MANAGER, 'email_verified_at' => now()]);
    $admin = User::factory()->create(['role' => User::ROLE_ADMIN, 'email_verified_at' => now()]);
    $target = User::factory()->create(['role' => User::ROLE_USER, 'email_verified_at' => now()]);

    $managerToken = $manager->createToken('api')->plainTextToken;
    $adminToken = $admin->createToken('api')->plainTextToken;

    $this->withHeader('Authorization', 'Bearer '.$adminToken)
        ->patchJson('/api/admin/users/'.$target->id.'/role', ['role' => User::ROLE_ADMIN])
        ->assertStatus(403);

    $this->withHeader('Authorization', 'Bearer '.$managerToken)
        ->patchJson('/api/admin/users/'.$target->id.'/role', ['role' => User::ROLE_ADMIN])
        ->assertStatus(200)
        ->assertJsonPath('data.role', User::ROLE_ADMIN);

    $this->withHeader('Authorization', 'Bearer '.$managerToken)
        ->patchJson('/api/admin/users/'.$manager->id.'/role', ['role' => User::ROLE_USER])
        ->assertStatus(422);
});
