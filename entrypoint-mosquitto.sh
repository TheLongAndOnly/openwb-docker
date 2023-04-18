#!/bin/bash

setup_web_port() {
    local warning="WARNING: Custom WEB_PORT not used"
    # Quietly exit early for empty or default
    if [[ -z "${1}" || "${1}" == '80' ]] ; then return ; fi

    if ! echo $1 | grep -q '^[0-9][0-9]*$' ; then
        echo "$warning - $1 is not an integer"
        return
    fi

    local -i web_port="$1"
    if (( $web_port < 1 || $web_port > 65535 )); then
        echo "$warning - $web_port is not within valid port range of 1-65535"
        return
    fi
    echo "Custom WEB_PORT set to $web_port"

    # Update Apache port
    sed -i '/Listen\s*80\s*$/ s/80/'$WEB_PORT'/g' /etc/apache2/ports.conf
    sed -i '/<VirtualHost\s*\*:80\s*>$/ s/80/'$WEB_PORT'/g' /etc/apache2/sites-enabled/000-default.conf
}

setup_web_port "$WEB_PORT"

# fix MTQQ clients when using ports other than 80
find /var/www/html/openWB -name "*.js" -type f -exec sed -i 's/Messaging.Client(location.host,/Messaging.Client(location.hostname,/g' {} +

# work around for config save problem -> map external file to a different name and copy of the real
# we need to ensure after save, this file shall be copied back to the conf folder
cp /var/www/html/openWB/config/openwb.conf /var/www/html/openWB/openwb.conf

service sudo start
service cron start
service mosquitto start
service apache2 start
sudo -u pi /var/www/html/openWB/runs/atreboot.sh
tail -f /var/log/openWB.log
