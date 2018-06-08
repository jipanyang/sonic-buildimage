#!/bin/bash -e

# Start processes in swss docker, except for rsyslogd and swssconfig load

supervisorctl start orchagent

supervisorctl start portsyncd

supervisorctl start intfsyncd

supervisorctl start neighsyncd

supervisorctl start intfmgrd

supervisorctl start vlanmgrd

supervisorctl start buffermgrd

# always start arp_update, VLAN may be created later
supervisorctl start arp_update

