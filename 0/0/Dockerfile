FROM serversideup/php:8.5-fpm-apache AS base

LABEL org.opencontainers.image.authors="dreitier GmbH <info@dreitier.com>" \
      org.opencontainers.image.title="swark, Swiss Architecture Knife" \
      org.opencontainers.image.description="Better software and infrastructure architecture documentation" \
      org.opencontainers.image.url="https://swiss-architecture-knife.github.com" \
      org.opencontainers.image.source="https://github.com/swiss-architecture-knife/docker" \
      org.opencontainers.image.vendor="dreitier GmbH"

USER root
RUN install-php-extensions gd intl

# Install default Java runtime and Graphviz
# man1 directory is required by the JRE's postinst script on slim Debian images
RUN set -ex; \
    mkdir -p /usr/share/man/man1; \
    apt-get update; \
    apt-get install -y --no-install-recommends default-jre-headless graphviz vim-tiny; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# We can pass USER_ID and GROUP_ID as build arguments
# to ensure the www-data user has the same UID and GID
# as the user running Docker.
ARG USER_ID
ARG GROUP_ID

# Switch to root so we can set the user ID and group ID
USER root

# Set the user ID and group ID for www-data
#RUN docker-php-serversideup-set-id www-data $USER_ID:$GROUP_ID  && \
#    docker-php-serversideup-set-file-permissions --owner $USER_ID:$GROUP_ID --service apache

# Drop privileges back to www-data    
USER www-data

############################################
# CI image
############################################
FROM base AS ci

# Sometimes CI images need to run as root
# so we set the ROOT user and configure
# the PHP-FPM pool to run as www-data
USER root
RUN echo "user = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf && \
    echo "group = www-data" >> /usr/local/etc/php-fpm.d/docker-php-serversideup-pool.conf

############################################
# Production Image
############################################
FROM base AS deploy
ARG RELEASE_FILE

USER root

# Extract the release straight from the build context; the archive never becomes an image layer.
# Extracting and chown'ing in a single layer avoids storing every file twice.
RUN --mount=type=bind,source=${RELEASE_FILE},target=/tmp/release.tar.bz2 \
    set -ex; \
    tar -xf /tmp/release.tar.bz2 -C /var/www/html --strip-components=1; \
    cp /var/www/html/.env.example /var/www/html/.env; \
    chown -R www-data:www-data /var/www/html

# Add helper scripts for sttartup
COPY --chmod=u+x entrypoint.d/02-set-default-app_key.sh /etc/entrypoint.d
COPY --chmod=u+x entrypoint.d/60-create-default-admin.sh /etc/entrypoint.d
COPY --chmod=u+x entrypoint.d/61-import-data.sh /etc/entrypoint.d

RUN chmod +x /etc/entrypoint.d/*

# Switch user
USER www-data

COPY entrypoint.sh \
    /usr/local/bin/
