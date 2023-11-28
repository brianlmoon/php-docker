#!/bin/sh

# Set these based on current host for config files
export FQDN=`hostname -f`
export FQDN_S=`hostname -s`

dockerize --template "/etc/ssmtp/ssmtp.conf.tmpl:/etc/ssmtp/ssmtp.conf"

exec "${@}"
