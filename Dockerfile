FROM debian:buster-slim
#FROM debian:stretch-slim
COPY entrypoint.sh /entrypoint.sh
RUN useradd -ms /bin/bash pi
RUN apt-get update && \
	apt-get install -y --no-install-recommends cron curl ca-certificates sudo python3 iproute2 net-tools && \
    rm -r /var/lib/apt/lists/*
RUN echo "* * * * * /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 10 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 20 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 30 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 40 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi - && \
	echo "* * * * * sleep 50 && /var/www/html/openWB/regel.sh >> /var/log/openWB.log 2>&1" | crontab -u pi -
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/snaptec/openWB/master/openwb-install.sh)"
#USER pi
#WORKDIR /home/pi
ENTRYPOINT ["/entrypoint.sh"]