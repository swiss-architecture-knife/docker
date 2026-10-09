#!/bin/bash
# Import defaults
# This runs after serversideup/php's 50-... default scripts so that we are having all database migrations executed.

echo "[swark] importing/upserting default importables like regulations"
php artisan swark:import:datamodel ./default-importables

CUSTOM_IMPORTABLES="custom-importables"

if [ -d "${CUSTOM_IMPORTABLES}" ]; then
	echo "[swark] custom importable directory exist, trying to import"

	php artisan swark:import:datamodel ./${CUSTOM_IMPORTABLES}
else
	echo "[swark] custom importable directory ${CUSTOM_IMPORTABLES}/ does not exist, skipping"
fi
