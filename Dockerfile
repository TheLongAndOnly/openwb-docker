FROM debian:buster-slim
ARG DEBIAN_FRONTEND=noninteractive
COPY entrypoint.sh /entrypoint.sh
RUN useradd -ms /bin/bash pi
RUN apt-get update && \
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
		sudo && \
    rm -r /var/lib/apt/lists/*
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=923479
# https://github.com/balena-io-library/base-images/issues/562
# should be fixed with openssl 1.1.1i-3 (buster is at 1.1.1d as of 2021-05-07)
RUN c_rehash
# Use https://www.piwheels.org for ARM platform Python wheels
RUN printf "[global]\nextra-index-url=https://www.piwheels.org/simple\n" > /etc/pip.conf
RUN echo "* * * * * /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 10 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 20 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 30 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 40 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 50 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi -
RUN echo "pi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/010_pi-nopasswd
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/snaptec/openWB/master/openwb-install.sh)"
#USER pi
#WORKDIR /home/pi
ENTRYPOINT ["/entrypoint.sh"]
