#!/bin/bash


SERVER=ora12c102rac0
USERNAME=jkstill
PASSWORD=grok
INSTANCE=p1.jks.com

unset SQLPATH

INSTANCE_NUM=$1

[[ -z $INSTANCE_NUM ]] && {
	echo
	echo Specify an instance - 1 or 2
	echo
	exit 1
}

sqlplus -S /nolog <<-EOF
	connect $USERNAME/$PASSWORD@//$SERVER${INSTANCE_NUM}/${INSTANCE}
	exec pseudo_sequence.do_work;
	exit;
EOF


