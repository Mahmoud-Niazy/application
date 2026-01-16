<?php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    'allowed_origins' => (function () {
        $origins = (string) env('CORS_ALLOWED_ORIGINS', '*');

        if ($origins === '*') {
            return ['*'];
        }

        return array_values(array_filter(array_map('trim', explode(',', $origins))));
    })(),

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,
];
