#!/bin/env bash

logFile=./ionice.log
cat /dev/null > "$logFile"
if [[ ! -e ./out ]]; then
    mkdir out
fi


log() {
    echo "$1" >> "$logFile"
}


run() {
    ionice -c"$nice" dd if=/dev/sda of=./out/f${nice} bs=100M count=10 oflag=direct
    rm -rf ./out/f${nice}
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
