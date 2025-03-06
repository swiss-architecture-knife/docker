# Running swark via docker-compose

First, clone this repository or just download the files in *this* directory.

On the command-line, you just have to run

```
docker-compose up
````

If you want to make `swark` available in your network, open the corresponding TCP port 8080 or 8443. You can do this in e.g. Fedora with

```
firewall-cmd --zone=public --add-port=8080/tcp --permanen
firewall-cmd --zone=public --add-port=8443/tcp --permanen
```