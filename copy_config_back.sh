#!/bin/bash
echo "saving config to docker mount"
OPENWBBASEDIR=/var/www/html/openWB
CONFIG_FILE_IN="$OPENWBBASEDIR/openwb.conf"
CONFIG_FILE_OUT="$OPENWBBASEDIR/config/openwb.conf"
cp $CONFIG_FILE_IN $CONFIG_FILE_OUT

