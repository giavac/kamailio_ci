#!/bin/sh
set -x

PATH_KAMAILIO_CFG=/usr/local/etc/kamailio/kamailio.cfg
KAMAILIO_BIN=/usr/local/sbin/kamailio

cp /root/scripts/kamailio.cfg $PATH_KAMAILIO_CFG

pkill kamailio

$KAMAILIO_BIN -f $PATH_KAMAILIO_CFG -DD -E -e
