#!/bin/env bash

logFile=./nice.log
cat /dev/null > "$logFile"

log() {
    echo "$1" >> "$logFile"
}


compress() {
    dd if=/dev/urandom bs=10K count=10000 2>/dev/null | nice -"$nice" gzip > /dev/null
}

com2() {
    echo "$nice"
}

test1() {
    nice=20
    { time compress; } 2>&1
}


test2() {
    nice=-19
    { time compress; } 2>&1
}

log "High nice $(test1)" &
log "Low nice $(test2)" &

