#!/bin/bash

set -Eeo pipefail

# set environment variables with docker secrets in /run/secrets/*
supportedSecrets=( "DB_PASSWORD"
                   "DATABASE_URL"
                   "APP_KEY"
                   "HASH_SALT"
                   "MAIL_PASSWORD"
                   "REDIS_PASSWORD"
                   "AWS_ACCESS_KEY_ID"
                   "AWS_SECRET_ACCESS_KEY"
                   "AWS_KEY"
                   "AWS_SECRET"
                  )

for secret in "${supportedSecrets[@]}"; do
    envFile="${secret}_FILE"
    if [ -n "${!envFile}" ] && [ -f "${!envFile}" ]; then
        val="$(< "${!envFile}")"
        export "${secret}"="$val"
        echo "${secret} environment variable was set by secret ${envFile}"
    fi
done
