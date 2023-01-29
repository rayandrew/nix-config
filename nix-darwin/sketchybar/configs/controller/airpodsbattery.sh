#!/usr/bin/env sh

AIRPODSBATTERY=$(system_profiler SPBluetoothDataType | grep 'Left Battery\|Right Battery' | awk '{printf $4}' | awk '{printf $1+$2}')
AIRPODICON=􁄡

if [[ $AIRPODSBATTERY = "" ]]; then
	sketchybar --set $NAME icon=$AIRPODICON label="unk |"
else
	sketchybar --set $NAME icon=$AIRPODICON label="$AIRPODSBATTERY% |"
fi
