# Running swark via docker-compose

First, clone this repository or just download the files in *this* directory.

On the command-line, you just have to run

```
docker-compose up
```

If you want to make `swark` available in your network, open the corresponding TCP port 8080 or 8443. You can do this in e.g. Fedora with

```
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --zone=public --add-port=8443/tcp --permanent
```

## Accessing swark

Go to [http://your-swark-host:8080](http://your-swark-host:8080). This is the frontend. You can access any of the backend UIs with the username `me@admin.com`. The password is automatically generated the first time on start-up. You see it in the `docker-compose`'s output.

If you want to set a static password the first or change the default admin email, set `ADMIN_EMAIL` or `ADMIN_PASSWORD` in the `docker-compose.yaml` file.

## Adding static content
To change static content in `swark`, navigate to the `laravel_data` volume on your host. On Fedora, this would be `//var/lib/docker/volumes/full_swark_data/_data/`. Create the following file so that `Strategy` content on the start page is updated:

```
cd $SWARK_DATA_DIR
mkdir -p strategy/overview
echo "Hello world" > big_picture.blade.php 
```
