#!/usr/bin/env sh

CPU=$(printf "%.2f\n" $(top -l 2 | grep -E "^CPU" | tail -1 | awk '{ print $3 + $5 }'))

CPUICON=􀫥

sketchybar -m --set $NAME icon=$CPUICON label="cpu $CPU% |"
