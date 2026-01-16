# API Documentation

## Overview

This project provides a REST API for a Flutter app and a minimal admin dashboard.

- Authentication: **Laravel Sanctum** (Bearer tokens)
- Base URL (local): `http://127.0.0.1:8000`
- Response format (all API endpoints):

```json
{
  "success": true,
  "message": "...",
  "data": {},
  "errors": null
}
```

## OTP note (assessment)

For this assessment:

- Email verification OTP is always **`1111`**
- Forgot password / reset password OTP is always **`1111`**
- Resend endpoints still exist and will always send `1111`
- Codes are **stored hashed** in DB (`code_hash`) even though fixed.

## Authentication

### Sanctum Bearer token

After successful login/verify/google login, you receive a token string.

Use it in requests:

- Header: `Authorization: Bearer <token>`

## Error codes

- `200` OK
- `201` Created
- `401` Unauthenticated / invalid credentials
- `403` Forbidden (role/authorization)
- `404` Not found
- `422` Validation error
- `429` Too many requests

Validation errors example:

```json
{
  "success": false,
  "message": "Validation error",
  "data": null,
  "errors": {
    "email": ["The email field is required."]
  }
}
```

---

## Auth Endpoints

### 1) Register

- Method: `POST`
- Route: `/api/auth/register`
- Auth: No

Request body:

```json
{
  "name": "John",
  "email": "john@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

Behavior:

- Creates user with role `user`
- `email_verified_at = null`
- Sends email verification OTP (fixed `1111`)
- **Does NOT return the OTP**

Success response (`201`):

```json
{
  "success": true,
  "message": "Registered successfully",
  "data": {
    "id": 1,
    "name": "John",
    "email": "john@example.com",
    "role": "user",
    "email_verified_at": null,
    "is_verified": false,
    "created_at": "...",
    "updated_at": "..."
  },
  "errors": null
}
```

### 2) Login

- Method: `POST`
- Route: `/api/auth/login`
- Auth: No

Request body:

```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

If user not verified:

- Status: `403`
- Message: `Account not verified`
- `data.needs_verification = true`

Example:

```json
{
  "success": false,
  "message": "Account not verified",
  "data": {"needs_verification": true},
  "errors": null
}
```

Success response (`200`):

```json
{
  "success": true,
  "message": "Logged in",
  "data": {
    "token": "...",
    "user": {
      "id": 1,
      "name": "John",
      "email": "john@example.com",
      "role": "user",
      "email_verified_at": "...",
      "is_verified": true,
      "created_at": "...",
      "updated_at": "..."
    }
  },
  "errors": null
}
```

### 3) Verify email

- Method: `POST`
- Route: `/api/auth/verify`
- Auth: No

Request body:

```json
{
  "email": "john@example.com",
  "code": "1111"
}
```

Behavior:

- Code must equal `"1111"`
- Attempts limited (max 5)
- Expiry concept applied (10 minutes)
- Sets `email_verified_at = now`
- Issues Sanctum token

Success response (`200`):

```json
{
  "success": true,
  "message": "Verified",
  "data": {
    "token": "...",
    "user": {"id": 1, "email": "john@example.com", "role": "user", "is_verified": true, "email_verified_at": "...", "name": "John", "created_at": "...", "updated_at": "..."}
  },
  "errors": null
}
```

### 4) Resend verification

- Method: `POST`
- Route: `/api/auth/resend-verification`
- Auth: No
- Rate limit:
  - Route throttle middleware: `throttle:1,1`
  - Plus DB-based `last_sent_at` check (60 seconds)

Request:

```json
{
  "email": "john@example.com"
}
```

Success (`200`):

```json
{
  "success": true,
  "message": "Verification code sent",
  "data": null,
  "errors": null
}
```

### 5) Forgot password

- Method: `POST`
- Route: `/api/auth/forgot-password`
- Auth: No
- Rate limit: `throttle:1,1`

Request:

```json
{
  "email": "john@example.com"
}
```

Behavior:

- Always returns generic message (does not reveal if email exists)
- If exists: sends OTP `1111` and stores hashed code

Success (`200`):

```json
{
  "success": true,
  "message": "If the account exists, a reset code was sent",
  "data": null,
  "errors": null
}
```

### 6) Reset password

- Method: `POST`
- Route: `/api/auth/reset-password`
- Auth: No

Request:

```json
{
  "email": "john@example.com",
  "code": "1111",
  "password": "newpassword123",
  "password_confirmation": "newpassword123"
}
```

Success (`200`):

```json
{
  "success": true,
  "message": "Password updated",
  "data": null,
  "errors": null
}
```

### 7) Google Login

- Method: `POST`
- Route: `/api/auth/google`
- Auth: No

Request:

```json
{
  "id_token": "<google_id_token_from_flutter>"
}
```

Server-side verification:

- Calls Google `tokeninfo` endpoint
- Validates `aud` matches `GOOGLE_CLIENT_ID` (if set)

Success (`200`):

```json
{
  "success": true,
  "message": "Logged in",
  "data": {
    "token": "...",
    "user": {
      "id": 1,
      "email": "john@example.com",
      "role": "user",
      "is_verified": true
    }
  },
  "errors": null
}
```

---

## Profile

### 8) Me

- Method: `GET`
- Route: `/api/me`
- Auth: Yes (`auth:sanctum`)

Headers:

- `Authorization: Bearer <token>`

Success (`200`):

```json
{
  "success": true,
  "message": "OK",
  "data": {
    "id": 1,
    "name": "John",
    "email": "john@example.com",
    "role": "user",
    "email_verified_at": "...",
    "is_verified": true,
    "created_at": "...",
    "updated_at": "..."
  },
  "errors": null
}
```

---

## Admin User Management

All endpoints below require:

- Auth: `auth:sanctum`
- Role: admin or manager (manager أعلى من admin)

### 9) List users

- Method: `GET`
- Route: `/api/admin/users`
- Role: `admin` or `manager`

Query params:

- `search` (optional)
- `page` (optional)

Success (`200`):

```json
{
  "success": true,
  "message": "OK",
  "data": {
    "items": [{"id": 1, "email": "...", "name": "...", "role": "user", "is_verified": true, "email_verified_at": "...", "created_at": "...", "updated_at": "..."}],
    "pagination": {
      "current_page": 1,
      "per_page": 15,
      "total": 1,
      "last_page": 1
    }
  },
  "errors": null
}
```

### 10) Show user

- Method: `GET`
- Route: `/api/admin/users/{id}`
- Role: `admin` or `manager`

Success (`200`):

```json
{
  "success": true,
  "message": "OK",
  "data": {"id": 1, "email": "...", "name": "...", "role": "user", "is_verified": true},
  "errors": null
}
```

### 11) Update user role (manager only)

- Method: `PATCH`
- Route: `/api/admin/users/{id}/role`
- Role: `manager` only

Request:

```json
{
  "role": "admin"
}
```

Rules:

- `role` must be in `user|admin|manager`
- Manager cannot demote self to lose access

Success (`200`):

```json
{
  "success": true,
  "message": "Role updated",
  "data": {"id": 2, "email": "...", "role": "admin"},
  "errors": null
}
```

### 12) Delete user (manager only)

- Method: `DELETE`
- Route: `/api/admin/users/{id}`
- Role: `manager` only

Success (`200`):

```json
{
  "success": true,
  "message": "User deleted",
  "data": null,
  "errors": null
}
```

---

## Manager Reports

### 13) Reports

- Method: `GET`
- Route: `/api/manager/reports`
- Auth: `auth:sanctum`
- Role: `manager` only

Success (`200`):

```json
{
  "success": true,
  "message": "OK",
  "data": {
    "total_users": 10,
    "verified_users": 7,
    "admins_count": 2,
    "managers_count": 1,
    "created_last_7_days": 3
  },
  "errors": null
}
```
