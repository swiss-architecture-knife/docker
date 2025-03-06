# swark's docker image

You can run swark with Docker images.

## Prerequisites

You can use [Docker](https://www.docker.com) and [docker-compose](https://docs.docker.com/compose/) to pull or build
and run a swark image, complete with a self-contained MySQL-compatible MariaDB database.

## Use swark docker image
swark runs on [serversideup's fpm-apache](https://hub.docker.com/r/serversideup/php/) image by default. If you want to use `fpm-nginx` or `fpm`-only, you have to rebuild the docker images on your own right now. 

```
docker run -d -p 8080:8080 swark/swark:latest
```

### Persistent data storage

To have a persistent storage for your data, you may want to create volumes for your db and for swark you will have to save the `/var/www/html/storage` and `/var/www/html/swark_content` directory.

Run a container with this named volume:
```console
docker run -d  \
    -v laravel_data:/var/www/html/storage \
    -v swark_content_data:/var/www/html/swark_content \
    swark/swark:latest
```

### Connect to a MariaDB/MySQL database
swark needs a MariaDB 10.11 or later database. You can either spin up your instance via Docker, use a host installation or use `docker-compose` to set up an environment.

Make sure, that you have created an empty database in your MariaDB/MySQL instance and have credentials to access that database.

```console
docker run -d \
    -e DB_HOST=mariadb_host_ip \
    -e DB_PORT=mariadb_port \
    -e DB_USERNAME=swark_user \
    -e DB_PASSWORD=swark_user_password \
    -e ADMIN_EMAIL=me@mydomain.com \
    -e AUTORUN_ENABLED=true \
    -e SWARK_CONTENT_PATH=./swark_content \
    swark/swark:latest
```

On startup, swark automatically creates all required database tables and creates an admin user `me@mydomain.com`. You can retrieve the generated password from the logs. 

## Use `docker-compose`
Clone this repository, read [.examples/full/README.md](.examples/full/README.md) and modify the `docker-compose.yaml` to your needs.
You can spin up a working swark environment with

```console
cd .examples/full
docker-compose up
```

## Environment variables

swark uses Laravel, so we are also using Laravel's configuration defaults. Please look through the Laravel documentation if you need more customization.
Furthermore, the docker image uses [serversideup/php](https://github.com/serversideup/docker-php). You can find a full list of further related customizations in [their docs](https://serversideup.net/open-source/docker-php/docs/reference/environment-variable-specification).

| Variable | Default | Description |
| --- | --- | --- |
| `ADMIN_EMAIL` | `string:<empty>` | If set, a new user with that email is created |
| `ADMIN_PASSWORD` | `string:<empty>` | If set and `ADMIN_EMAIL` is present, this password is set for the initial user. If `ADMIN_PASSWORD` is *not* set but `ADMIN_EMAIL` is, a password is generated during first startup. |
| `AUTORUN_ENABLED` | `bool:false` | Run database migrations during startups. Set it to `true`. |
| `APP_KEY` | `char(32):<random_string> | Application key for Laravel application. If you do not define one, a random string with length of 32 is created. If you define an `APP_KEY` it *must* have a length of exactly 32 characters. |
| `SWARK_CONTENT_PATH` | `string:storage/app/swark/_default` | Content repository in which static content is stored. |
| `DB_HOST` | `string:127.0.0.1` | MariaDB hostname or IP |
| `DB_PORT` | `int:3306` | MariaDB instance port |
| `DB_DATABASE` | `string:swark` | Database to use |
| `DB_USERNAME` | `string:root` | Database user to connect with |
| `DB_PASSWORD` | `string:<empty>` | Database user's password to connect with |
