#!/usr/bin/env bash

PAGE=$(pagesize)
TOGB=$((1024 ** 3))
ANONYMOUS=$(vm_stat | grep 'Anonymous' | awk '{print $3/1024}')
PURGEABLE=$(vm_stat | grep 'purgeable' | awk '{print (($3*$tagb)/1024)}')
UNUSED=$(top -l 1 | grep 'unused' | awk '{print $8}')

MEMICON=􀫦
APP_MEMORY=$(printf "%.2f\n" $(awk "BEGIN {print ((((($ANONYMOUS*$PAGE)-$PURGEABLE-$UNUSED)/$TOGB)*1024))}"))
WIRED_MEMORY=$(printf "%.2f\n" $(top -l 1 | grep 'wired' | awk -F '(' '{print $2}' | awk '{print $1/1024}'))
COMPRESSED=$(printf "%.2f\n" $(top -l 1 | grep 'compressor' | awk -F '(' '{print $2}' | awk '{print $3/1024}'))
MEMORY_USAGE=$(printf "%.2f\n" $(awk "BEGIN {print (($APP_MEMORY+$WIRED_MEMORY+$COMPRESSED)+0.529)}"))

sketchybar -m --set $NAME icon=$MEMICON label="mem $MEMORY_USAGE GB |"
