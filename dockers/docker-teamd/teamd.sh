#!/usr/bin/env bash

TEAMD_CONF_PATH=/etc/teamd

function start_app {
    rm -f /var/run/teamd/*
    if [ "$(ls -A $TEAMD_CONF_PATH)" ]; then
        for f in $TEAMD_CONF_PATH/*; do
            members=""
            pc_conf="${f:11}"
            for member in $(sonic-cfggen -d -v "PORTCHANNEL['"${pc_conf%.*}"']['members'] | join(' ')" ); do
                members="$members"" $member"
                logger -p notice "teamd set link $member down"
                ip link set $member down
            done
            logger -p notice "teamd create ""$f"
            teamd -f $f -d
            for member in $members; do
                if [ "down" == "$(sonic-cfggen -d -v "PORT['"$member"']['admin_status']")" ]; then
                    logger -p notice "teamd shutdown ""$member"
                    ip link set $member down
                fi
            done
        done
        for pc in `sonic-cfggen -d -v "PORTCHANNEL.keys() | join(' ') if PORTCHANNEL"`; do
            ip link set $pc up
        done

    fi
    teamsyncd &
}

function clean_up {
    if [ "$(ls -A $TEAMD_CONF_PATH)" ]; then
        for f in $TEAMD_CONF_PATH/*; do
            teamd -f $f -k
        done
    fi
    pkill -9 teamsyncd
    exit
}

trap clean_up SIGTERM SIGKILL

start_app
read
