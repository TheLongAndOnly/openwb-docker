# openwb-docker

Run OpenWB in a container.

[openWB](http://openwb.de) is a great solution for charging your EV using surplus solar energy and home automation. The product range starts from a standalone solution running on a Raspberry Pi to a complete wallbox with a display. But what if you just want to try the software and test the available integrations?

This project allows to run the same open source software which powers the openWB products in a container.

I'm picking up the good work from https://github.com/IngmarStein/openwb-docker, trying to drive it to a working solutions. This has been build and test on a Raspberry Pi 4 with 4GB RAM and Debian Bullseye as host OS.

## Get Started

1) Clone this repo
2) docker compose build
3) docker compose up -d
4) Connect to http://your-ip:8888/openWB
  
You should be able to see and access the WebUI of **openWB**
  
## Troubleshooting

The settings file **openWB.conf** seems to be only updated if the variable exists. the original file deployed from openWB is incomplete and configuraiton does not work properly trough the web interface. I added the variables I figured out missing, but there might be more.

The container does not contain mosquitto. It is assumed the host has an instance running. Ensure port 9001 is open for WebSocket connections

If you need a solution with integrated mosquitto, use
2) docker compose -f docker-compose-mosquitto.yml build
3) docker compose -f docker-compose-mosquitto.yml up -d
