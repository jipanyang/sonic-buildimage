#!/bin/bash -e

# stop processes in swss docker, except for rsyslogd and swssconfig load

supervisorctl stop orchagent

supervisorctl stop portsyncd

supervisorctl stop intfsyncd

supervisorctl stop neighsyncd

supervisorctl stop intfmgrd

supervisorctl stop vlanmgrd

supervisorctl stop buffermgrd

supervisorctl stop arp_update
