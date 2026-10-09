#!/bin/bash

if [ -z "${APP_KEY:-}" -o "$APP_KEY" = "Th1s1sARandom5tringW1thLength32." ]; then
    php artisan key:generate --no-interaction
else
    echo "[swark] APP_KEY already set"
fi