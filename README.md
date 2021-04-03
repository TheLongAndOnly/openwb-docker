# openwb-docker

Run OpenWB in a container.

[openWB](http://openwb.de) is a great solution for charging your EV using surplus solar energy and home automation. The product range starts from a standalone solution running on a Raspberry Pi to a complete wallbox with a display. But what if you just want to try the software and test the available integrations?

This project allows to run the same open source software which powers the openWB products in a container.

## Using Docker

1. Build the image: `docker build -t openwb .`
2. Create and run a container: `docker run --network host -d -e WEB_PORT=8888 --cap-add=NET_ADMIN -v ./openwb.conf:/var/www/html/openWB/openwb.conf openwb`

## Using Docker Compose

Adjust configuration in `docker-compose.yml` and run `docker-compose up -d`.