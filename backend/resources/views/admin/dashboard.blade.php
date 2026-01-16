@extends('admin.layout')

@section('title', 'Admin Overview')

@section('content')
    <div class="d-flex align-items-center justify-content-between mb-3">
        <h1 class="h4 mb-0">Overview</h1>
        <a href="{{ route('admin.users.index') }}" class="btn btn-primary btn-sm">Manage Users</a>
    </div>

    <div class="row g-3">
        <div class="col-12 col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="text-muted">Total users</div>
                    <div class="display-6">{{ $stats['total_users'] }}</div>
                </div>
            </div>
        </div>
        <div class="col-12 col-md-6">
            <div class="card shadow-sm">
                <div class="card-body">
                    <div class="text-muted">Verified users</div>
                    <div class="display-6">{{ $stats['verified_users'] }}</div>
                </div>
            </div>
        </div>
    </div>

    <div class="card shadow-sm mt-3">
        <div class="card-header bg-white fw-semibold">Details</div>
        <div class="table-responsive">
            <table class="table table-striped mb-0">
                <tbody>
                    <tr><td>Admins</td><td class="text-end">{{ $stats['admins_count'] }}</td></tr>
                    <tr><td>Managers</td><td class="text-end">{{ $stats['managers_count'] }}</td></tr>
                    <tr><td>Created last 7 days</td><td class="text-end">{{ $stats['created_last_7_days'] }}</td></tr>
                </tbody>
            </table>
        </div>
    </div>
@endsection
