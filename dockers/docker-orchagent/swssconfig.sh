#!/usr/bin/env bash

set -e

function fast_reboot {
  case "$(cat /proc/cmdline)" in
    *fast-reboot*)
      if [[ -f /fdb.json ]];
      then
        swssconfig /fdb.json
        rm -f /fdb.json
      fi

      if [[ -f /arp.json ]];
      then
        swssconfig /arp.json
        rm -f /arp.json
      fi

      if [[ -f /default_routes.json ]];
      then
        swssconfig /default_routes.json
        rm -f /default_routes.json
      fi

      ;;
    *)
      ;;
  esac
}

# Wait until swss.sh in the host system create file swss:/ready
until [[ -e /ready ]]; do
    sleep 0.1;
done

rm -f /ready

# Restore FDB and ARP table ASAP
fast_reboot

HWSKU=`sonic-cfggen -d -v "DEVICE_METADATA['localhost']['hwsku']"`

# Don't load json config for warm start
WARM_START=`redis-cli -n 6 hget "WARM_RESTART_TABLE|orchagent" restart_count`
if [ -n "$WARM_START" ] && [ "$WARM_START" != "0" ]; then
  exit 0
fi

SWSSCONFIG_ARGS="00-copp.config.json ipinip.json ports.json switch.json "

for file in $SWSSCONFIG_ARGS; do
    swssconfig /etc/swss/config.d/$file
    sleep 1
done
