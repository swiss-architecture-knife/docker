#!/bin/bash
# Create a default admin if none has been defined.
# This runs after serversideup/php's 50-... default scripts so that we are having all database migrations executed.

if [ ! -z "${ADMIN_EMAIL}" ]; then
    echo "[swark] Upserting admin user..."

    php artisan swark:create-user \
        --name=${ADMIN_EMAIL} \
        --email=${ADMIN_EMAIL} \
        --password${ADMIN_PASSWORD:+=$ADMIN_PASSWORD} \
        --is-admin \
        --skip-on-existing-user

else
    echo "[swark] Not creating/updating any admin user"
fi