*IMPORTANT: This project is unmaintained*

*Due to lack of interest in supporting a containerized environment by the OpenWB team, this project is no longer updated and no support is provided.*

# openwb-docker

Run OpenWB in a container.

[openWB](http://openwb.de) is a great solution for charging your EV using surplus solar energy and home automation. The product range starts from a standalone solution running on a Raspberry Pi to a complete wallbox with a display. But what if you just want to try the software and test the available integrations?

This project allows to run the same open source software which powers the openWB products in a container.

## Get Started

Choose one of the methods below to create and run a container with openWB:

Using Docker:

```shell
docker run --network host -d -e WEB_PORT=8888 --cap-add=NET_ADMIN --name openwb --restart always -v "$(pwd)/openwb.conf:/var/www/html/openWB/openwb.conf" ingmarstein/openwb
```

Using Docker Compose: adjust configuration in `docker-compose.yml` and run
```shell
docker-compose up -d
```

Using [Portainer](https://www.portainer.io):

1. start creating a new container with the following settings:
<img width="1168" src="https://user-images.githubusercontent.com/490610/117583971-82f7cf80-b10a-11eb-8a5b-d83d78eb9dc3.png">
2. navigate to the advanced settings and set up the bind mounts: <img width="1171" alt="Bildschirmfoto 2021-05-09 um 21 00 32" src="https://user-images.githubusercontent.com/490610/117583991-a02c9e00-b10a-11eb-9123-11f988a9c91c.png">
3. select the `host` network: <img width="1175" src="https://user-images.githubusercontent.com/490610/117583995-a28ef800-b10a-11eb-91d7-4ef34ce91d9c.png">
4. set required environment variables: <img width="1172" src="https://user-images.githubusercontent.com/490610/117583997-a4f15200-b10a-11eb-9b1a-81821d22c2d8.png">
5. choose a restart policy: <img width="1174" src="https://user-images.githubusercontent.com/490610/117584000-a884d900-b10a-11eb-9f08-a4ad4a26aac8.png">
6. enable the `init` flag: <img width="1170" src="https://user-images.githubusercontent.com/490610/117584004-ab7fc980-b10a-11eb-89e0-d06b16967cd3.png">
7. enable the `NET_ADMIN` capability <img width="1174" src="https://user-images.githubusercontent.com/490610/117584009-ad498d00-b10a-11eb-93ee-eebc63a59fed.png">
8. click "deploy the container"

Once the container is started, navigate to `http://${HOST}:${WEB_PORT}/openWB` to access the openWB web interface.

It is recommended to mount `openwb.conf` from the host so that configuration changes persist a container restart and to provide a `logdata` directory to persist the long-term log data.
