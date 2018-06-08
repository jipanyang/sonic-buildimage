#!/usr/bin/env bash

# Don't enable temp view if noUseTempView dir exists
NO_TEMP_VIEW="/var/run/redis/noUseTempView"
if [ -d "$NO_TEMP_VIEW" ]; then
    /usr/bin/syncd -p /usr/share/sonic/device/vswitch/brcm.profile.ini
else
    /usr/bin/syncd -u -p /usr/share/sonic/device/vswitch/brcm.profile.ini
fi

