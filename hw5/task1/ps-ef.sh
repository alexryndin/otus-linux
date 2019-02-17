#!/bin/env bash

out() {
    for pidpath in $(find /proc/ -maxdepth 1 -regex "^/proc/[0-9]+$"); do
        pid=$(echo $pidpath | awk 'BEGIN {FS ="/"} {print $3, '\t';}')
        #set -x
        tty=$(readlink $pidpath/fd/0 | cut -d "/" -f3)
        [ -z "$tty" ] && tty="?"
        #set +x
        cmdline=$(cat $pidpath/cmdline)
        [ -z "$cmdline" ] && cmdline=$(cut -d " " -f2 $pidpath/stat)
        stat=$(cut -d " " -f3 $pidpath/stat)
        tpm=$(getconf CLK_TCK)
        stat14=$(cut -d " " -f14 $pidpath/stat)
        stat15=$(cut -d " " -f15 $pidpath/stat)
        time=$((($stat14+$stat15)/$tpm))

        printf "%s\t%s\t%s\t%s\t%s\n" $pid $tty $stat $time $cmdline
    done
}

printf "PID\tTTY\tSTAT\tTIME\tCOMMAND\n"
out 2>/dev/null
