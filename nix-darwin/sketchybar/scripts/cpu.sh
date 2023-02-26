#!/usr/bin/env sh

# CPU=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
# CORE=$(sysctl -n hw.ncpu)
# USAGE=$(echo "$CPU / $CORE" | bc -l)
# USAGE=$(printf "%.2f\n" "$USAGE")
USAGE=$(printf "%.2f\n" $(top -l 2 | grep -E "^CPU" | tail -1 | awk '{ print $3 + $5 }'))

CPUICON=􀫥

sketchybar -m --set "$NAME" icon=$CPUICON label="$USAGE%"
