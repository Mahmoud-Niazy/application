<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

## Project

Laravel (v12) REST API (API-first) + minimal Admin Dashboard for a Flutter app.

Features:

- Auth: Laravel Sanctum
- Roles: user / admin / manager (manager أعلى من admin)
- Email verification via OTP (fixed code = 1111 for assessment)
- Forgot password via OTP (fixed code = 1111 for assessment)
- Google login: accepts Google ID token, verifies server-side, issues app token
- Admin endpoints for user management
- Manager-only reports endpoint
- Minimal Blade admin dashboard (login + overview + users + role change)

Full API docs: see `APIDocumentation.md`.

## Setup

1) Install dependencies

```bash
composer install
```

2) Create `.env`

```bash
copy .env.example .env
php artisan key:generate
```

3) Configure DB in `.env`

The default `.env.example` uses MySQL.

4) Migrate + seed

```bash
php artisan migrate
php artisan db:seed
```

Seeded local users:

- `manager@example.com` / `password`
- `admin@example.com` / `password`
- `user@example.com` / `password`

5) Run

```bash
php artisan serve
```

## Mail configuration

OTP emails are sent via Laravel Mail.

Development options:

- `MAIL_MAILER=log` (default) to log emails
- Mailpit (SMTP) or Mailtrap (SMTP)

Production:

- Configure your SMTP provider in `.env` (`MAIL_HOST`, `MAIL_PORT`, `MAIL_USERNAME`, `MAIL_PASSWORD`).

Email content includes the OTP code (fixed `1111` for assessment).

## Quick curl examples

Base URL: `http://127.0.0.1:8000`

Register:

```bash
curl -X POST http://127.0.0.1:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test1@example.com","password":"password123","password_confirmation":"password123"}'
```

Verify email (OTP is always `1111`):

```bash
curl -X POST http://127.0.0.1:8000/api/auth/verify \
  -H "Content-Type: application/json" \
  -d '{"email":"test1@example.com","code":"1111"}'
```

Login:

```bash
curl -X POST http://127.0.0.1:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test1@example.com","password":"password123"}'
```

Get profile:

```bash
curl http://127.0.0.1:8000/api/me \
  -H "Authorization: Bearer YOUR_TOKEN"
```

Admin list users (admin or manager token):

```bash
curl http://127.0.0.1:8000/api/admin/users \
  -H "Authorization: Bearer YOUR_TOKEN"
```

Manager report:

```bash
curl http://127.0.0.1:8000/api/manager/reports \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Admin Dashboard

- URL: `/admin/login`
- Only `admin` / `manager` can log in.

## Tests

```bash
php artisan test
```
