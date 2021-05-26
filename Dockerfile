FROM debian:buster-slim
ARG DEBIAN_FRONTEND=noninteractive
COPY entrypoint.sh /entrypoint.sh
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN useradd -ms /bin/bash pi \
    && apt-get update \
	&& apt-get install -y --no-install-recommends \
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
    && rm -r /var/lib/apt/lists/* \
	&& c_rehash \
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=923479
# https://github.com/balena-io-library/base-images/issues/562
# should be fixed with openssl 1.1.1i-3 (buster is at 1.1.1d as of 2021-05-07)
# Use https://www.piwheels.org for ARM platform Python wheels
    && printf "[global]\nextra-index-url=https://www.piwheels.org/simple\n" > /etc/pip.conf \
    && printf "* * * * * /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 10 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 20 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 30 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 40 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n\
* * * * * sleep 50 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1\n" | crontab -u pi - \
    && echo "pi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/010_pi-nopasswd \
    && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/snaptec/openWB/master/openwb-install.sh)"
#USER pi
#WORKDIR /home/pi
ENTRYPOINT ["/entrypoint.sh"]
