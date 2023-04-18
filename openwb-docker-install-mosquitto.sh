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
curl -fsSL --output /openwb-install-patched.sh https://raw.githubusercontent.com/snaptec/openWB/master/openwb-install.sh

# patch the install file
perl -i -pe 's/raspberrypi-kernel-headers//g' /openwb-install-patched.sh
perl -i -pe 's/i2c\-tools//g' /openwb-install-patched.sh
#perl -i -pe 's/mosquitto\s*mosquitto-client/mosquitto-client/g' /openwb-install-patched.sh
perl -i -p0e 's/if\s*grep\s*\-Fxq\s*\"i2c\-bcm2835\".*?\nfi//s' /openwb-install-patched.sh
perl -i -pe 's/sudo\s*service\s*mosquitto\s*start//g' /openwb-install-patched.sh
#perl -i -p0e 's/if\s*\[\s*!\s*\-f\s*\/etc\/mosquitto\/conf\.d\/openwb\.conf.*?\nfi//s' /openwb-install-patched.sh
perl -i -p0e 's/echo\s*\"check\s*for\s*MCP4725\".*?\nfi//s' /openwb-install-patched.sh
perl -i -pe 's/sudo\s*\-u\s*pi\s*\/var\/www\/html\/openWB\/runs\/atreboot\.sh//g' /openwb-install-patched.sh

# run the patched installer
echo "Executing openwb-install-patched"
chmod 755 /openwb-install-patched.sh
cat /openwb-install-patched.sh
/openwb-install-patched.sh

printf "* * * * * /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 10 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 20 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 30 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 40 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 50 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
*/10 * * * * /copy_config_back.sh >> /var/log/openWB.log 2>&1\n" | crontab -u pi -
echo "pi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/010_pi-nopasswd

usermod -aG www-data pi

OPENWBBASEDIR=/var/www/html/openWB
# get a modified atreboot file
#perl -i -p0e 's/#\s*check\s*for\s*mosquitto\s*packages.*?\n\s*fi//s' ${OPENWBBASEDIR}/runs/atreboot.sh
#perl -i -p0e 's/#\s*check\s*for\s*mosquitto\s*configuration.*?\n\s*fi//s' ${OPENWBBASEDIR}/runs/atreboot.sh

cp ${OPENWBBASEDIR}/runs/atreboot.sh ${OPENWBBASEDIR}/runs/atreboot-once.sh

perl -i -pe 's/sudo\s*\/usr\/sbin\/apachectl\s*\-k\s*graceful//g' ${OPENWBBASEDIR}/runs/atreboot-once.sh
perl -i -pe 's/openwbRunLoggingOutput\s*at_reboot/at_reboot/g' ${OPENWBBASEDIR}/runs/atreboot-once.sh
perl -i -pe 's/mosquitto_pub/echo \"Skip mosquitto_pub\" #mosquitto_pub/g' ${OPENWBBASEDIR}/runs/atreboot-once.sh

# avoid installing php7.0 stuff
touch /home/pi/ssl_patched
echo "Executing atreboot-once"
chmod 755 ${OPENWBBASEDIR}/runs/atreboot-once.sh
cat ${OPENWBBASEDIR}/runs/atreboot-once.sh
sudo -u pi ${OPENWBBASEDIR}/runs/atreboot-once.sh
