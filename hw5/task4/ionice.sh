#!/bin/env bash

logFile=./nice.log
cat /dev/null > "$logFile"

log() {
    echo "$1" >> "$logFile"
}


run() {
    ionice -c"$nice" dd if=/dev/sda of=/dev/null bs=100K count=10000
}

com2() {
    echo "$nice"
}

test1() {
    nice=1
    { time run; } 2>&1
}


test2() {
    nice=3
    { time run; } 2>&1
}

log "Low nice $(test1)" &
log "High nice $(test2)" &
