#!/bin/bash
useradd -ms /bin/bash pi

# install required software
apt-get update
apt-get install -y --no-install-recommends \
		apt-utils \
		ca-certificates \
		cron \
		curl \
		iproute2 \
		iputils-ping \
		net-tools \
		python3 \
		python3-dev \
		sudo \
		systemd \
		git \
		libssl1.1 \
		ripgrep

#
rm -r /var/lib/apt/lists/*
c_rehash

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=923479
# https://github.com/balena-io-library/base-images/issues/562
# should be fixed with openssl 1.1.1i-3 (buster is at 1.1.1d as of 2021-05-07)
# Use https://www.piwheels.org for ARM platform Python wheels
printf "[global]\nextra-index-url=https://www.piwheels.org/simple\n" > /etc/pip.conf

# get the original install file
curl -fsSL --output /openwb-install-orig.sh https://raw.githubusercontent.com/snaptec/openWB/master/openwb-install.sh

# patch the install file
cat /openwb-install-orig.sh | sed -e '/s/raspberrypi-kernel-headers //g' -e '/s/mosquitto //g' \
		| sed -e 's/if grep -Fxq "i2c-bcm2835".+fi//g' \
		| sed -e 's/sudo service mosquitto start/#sudo service mosquitto start/g' \
		| sed -e 's/if [ ! -f \/etc\/mosquitto\/conf.d\/openwb.conf.+fi//g' \
		| sed -e 's/echo "check for MCP4725".+fi//g' \
		| sed -e 's/sudo -u pi \/var\/www\/html\/openWB\/runs\/atreboot.sh//g' > /openwb-install-patched.sh

# run the patched installer
/openwb-install-patched.sh

# get a modified atreboot file
cat /var/www/html/openWB/runs/atreboot.sh | sed -e 's/# check for mosquitto packages.+fi//g' \
		| sed -e 's/# check for mosquitto configuration.+fi//g' \
		| sed -e 's/sudo \/usr\/sbin\/apachectl -k graceful//g' \
		| sed -e 's/openwbRunLoggingOutput at_reboot//at_reboot//g' > /atreboot-once.sh

# avoid installing php7.0 stuff
touch /home/pi/ssl_patched
/atreboot-once.sh

printf "* * * * * /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 10 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 20 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 30 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 40 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 50 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n" | crontab -u pi -
echo "pi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/010_pi-nopasswd
