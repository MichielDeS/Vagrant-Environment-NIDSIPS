#!/bin/bash

TARGET="172.10.0.10"
INTERVAL=5
LOGFILE="/home/vagrant/nmap_scan.log"

touch $LOGFILE

perform_scan() {
    while true
    do
        echo "Running nmap scan on $TARGET..." >> $LOGFILE 2>&1
        nmap -p- $TARGET >> $LOGFILE 2>&1
        echo "Scan completed. Waiting for $INTERVAL seconds before next scan." >> $LOGFILE 2>&1
        sleep $INTERVAL
    done
}

perform_scan &

disown
