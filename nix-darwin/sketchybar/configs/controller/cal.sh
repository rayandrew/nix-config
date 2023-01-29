#!/usr/bin/env sh

CAL=$(date '+%a %d %b')

CALICON=􀉉

sketchybar --set "$NAME" icon="$CALICON" label="$CAL |"
