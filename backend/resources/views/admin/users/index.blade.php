@extends('admin.layout')

@section('title', 'Users')

@section('content')
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 mb-0">Users</h1>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <form method="GET" action="{{ route('admin.users.index') }}" class="row g-2 align-items-end">
                <div class="col-12 col-md-6">
                    <label class="form-label">Search</label>
                    <input type="text" class="form-control" name="search" value="{{ $search }}" placeholder="Search name/email">
                </div>
                <div class="col-12 col-md-auto">
                    <button type="submit" class="btn btn-primary">Search</button>
                    <a href="{{ route('admin.users.index') }}" class="btn btn-outline-secondary">Reset</a>
                </div>
            </form>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Verified</th>
                        <th class="text-end"></th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($users as $user)
                        <tr>
                            <td class="text-muted">{{ $user->id }}</td>
                            <td class="fw-semibold">{{ $user->name }}</td>
                            <td>{{ $user->email }}</td>
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
                            <td>
                                @if ($user->email_verified_at)
                                    <span class="badge bg-success">yes</span>
                                @else
                                    <span class="badge bg-warning text-dark">no</span>
                                @endif
                            </td>
                            <td class="text-end">
                                <a href="{{ route('admin.users.show', $user) }}" class="btn btn-outline-dark btn-sm">View</a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center text-muted py-4">No users found.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
        <div class="card-body border-top">
            {{ $users->withQueryString()->links() }}
        </div>
    </div>
@endsection
