#!/bin/sh
# bar-append.sh — keep running in background

while :; do
    ./bar.sh &
    if line=$(tail -n1 /tmp/bar-base.txt 2>/dev/null); then
        ts=$(date +"%H:%M:%S.%1N")
        echo "$line $ts" > /tmp/bar.txt
    fi
    sleep 1
done

