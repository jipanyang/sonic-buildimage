#!/bin/bash -e

# Start processes in swss docker, except for rsyslogd and swssconfig load

supervisorctl start orchagent

supervisorctl start portsyncd

supervisorctl start intfsyncd

supervisorctl start neighsyncd

supervisorctl start intfmgrd

supervisorctl start vlanmgrd

supervisorctl start buffermgrd

# Start arp_update when VLAN exists
VLAN=`sonic-cfggen -d -v 'VLAN.keys() | join(" ") if VLAN'`
if [ "$VLAN" != "" ]; then
    supervisorctl start arp_update
fi
