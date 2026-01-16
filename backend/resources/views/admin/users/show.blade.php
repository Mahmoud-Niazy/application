@extends('admin.layout')

@section('title', 'User Details')

@section('content')
    <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
            <h1 class="h4 mb-1">User #{{ $user->id }}</h1>
            <div class="text-muted">{{ $user->email }}</div>
        </div>
        <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary btn-sm">Back</a>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-header bg-white fw-semibold">Profile</div>
        <div class="table-responsive">
            <table class="table mb-0">
                <tbody>
                    <tr><td class="text-muted" style="width: 200px;">Name</td><td class="fw-semibold">{{ $user->name }}</td></tr>
                    <tr><td class="text-muted">Email</td><td>{{ $user->email }}</td></tr>
                    <tr>
                        <td class="text-muted">Role</td>
                        <td>
                            @php
                                $roleClass = match ($user->role) {
                                    'manager' => 'bg-success',
                                    'admin' => 'bg-primary',
                                    default => 'bg-secondary',
                                };
                            @endphp
                            <span class="badge {{ $roleClass }}">{{ $user->role }}</span>
                        </td>
                    </tr>
                    <tr>
                        <td class="text-muted">Email verified</td>
                        <td>
                            @if ($user->email_verified_at)
                                <span class="badge bg-success">yes</span>
                                <span class="text-muted ms-2">{{ $user->email_verified_at }}</span>
                            @else
                                <span class="badge bg-warning text-dark">no</span>
                            @endif
                        </td>
                    </tr>
                    <tr><td class="text-muted">Created</td><td class="text-muted">{{ $user->created_at }}</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    @if (auth()->user() && auth()->user()->hasRole(\App\Models\User::ROLE_MANAGER))
        <div class="card shadow-sm">
            <div class="card-header bg-white fw-semibold">Change Role (manager only)</div>
            <div class="card-body">
                <form method="POST" action="{{ route('admin.users.updateRole', $user) }}" class="row g-2 align-items-end">
                    @csrf
                    <div class="col-12 col-md-4">
                        <label class="form-label">Role</label>
                        <select name="role" class="form-select">
                            <option value="user" @selected($user->role === 'user')>user</option>
                            <option value="admin" @selected($user->role === 'admin')>admin</option>
                            <option value="manager" @selected($user->role === 'manager')>manager</option>
                        </select>
                    </div>
                    <div class="col-12 col-md-auto">
                        <button type="submit" class="btn btn-dark">Update</button>
                    </div>
                </form>
            </div>
        </div>
    @endif
@endsection
