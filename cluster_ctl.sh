#!/bin/bash
#
# script Name: /opt/cluster_ctl.sh
# Author: Andrew Fore, andy.fore@arfore.com
# Purpose: a simple script to control the status of a node heartbeat in a cluster
#

# Port numbers should be in standard bash array format
PORTS_TO_CHECK=(80 443)

# name of the process to check in output of ps
PROCESS_NAME="httpd"

# Heartbeat file path and naming information
HEARTBEAT_PATH="/var/www/html/heartbeats/"
HEARTBEAT_IN_FILE="heartbeat.html"
HEARTBEAT_OUT_FILE="heartbeat.html.out"


# Rename the heartbeat file
#mv /var/www/html/heartbeats/hertbeat.html /var/www/html/heartbeats/heartbeat.html.out

check_current_status()
{

    tmp_ports=""
    for i in "${PORTS_TO_CHECK[@]}"; do
      tmp_ports+=":$i|"
    done

    # get the current number of processes for the configured service name
    echo "Current $PROCESS_NAME process count: "
    ps -ef | grep -v grep | grep $PROCESS_NAME | wc -l
    echo ""

    # get current network port states for the configured port numbers
    echo "Current netstat port listeners"
    netstat -ntlp | egrep "${tmp_ports%?}"
    echo ""

    # get the current heart file name
    echo "Node name: `hostname -s`"
    echo -n "Status: "
    [ -f "$HEARTBEAT_PATH$HEARTBEAT_IN_FILE" ] && echo "** IN ROTATION **"
    [ -f "$HEARTBEAT_PATH$HEARTBEAT_OUT_FILE" ] && echo "** NOT IN ROTATION **"
}

disable_node()
{
    # disable the heartbeat
    echo "Removing node: `hostname` from rotation"
    mv /var/www/html/heartbeats/heartbeat.html /var/www/html/heartbeats/heartbeat.html.out
}

enable_node()
{
    # enable the heartbeat
    echo "Adding node: `hostname` to rotation"
    mv /var/www/html/heartbeats/heartbeat.html.out /var/www/html/heartbeats/heartbeat.html
}

usage()
{
    echo "usage: cluster_ctl.sh -cde"
    echo ""
    echo "-c  outputs the number of processes for the configured service, lists the "
    echo "    configured listeners for the ports, and the node status based on the "
    echo "    configured heartbeat file"
    echo ""
    echo "-d  disables the service configuration for the load balancer by moving "
    echo "    the current heartbeat file to an unexpected name"
    echo ""
    echo "-e  enables the service configuration for the load balancer by moving "
    echo "    the heartbeat file back to the expected name"
}

if [ -z "$1" ]; then
   usage
fi

while getopts "cde" opt; do
  case $opt in
    c) check_current_status
       ;;
    d) disable_node
       ;;
    e) enable_node
       ;;
    \?)
       usage && exit 1 ;;
  esac
done
