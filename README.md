# openwb-docker

Run OpenWB in a container.

[openWB](http://openwb.de) is a great solution for charging your EV using surplus solar energy and home automation. The product range starts from a standalone solution running on a Raspberry Pi to a complete wallbox with a display. But what if you just want to try the software and test the available integrations?

This project allows to run the same open source software which powers the openWB products in a container.

## Get Started

Choose one of the methods below to create and run a container with openWB:

Using Docker:

```shell
docker run --network host -d -e WEB_PORT=8888 --cap-add=NET_ADMIN -v ./openwb.conf:/var/www/html/openWB/openwb.conf ingmarstein/openwb
```

Using Docker Compose: adjust configuration in `docker-compose.yml` and run
```shell
docker-compose up -d
```

Once the container is started, navigate to `http://${HOST}:${WEB_PORT}/openWB` to access the openWB web interface.

It is recommended to mount `openwb.conf` from the host so that configuration changes persist a container restart.
