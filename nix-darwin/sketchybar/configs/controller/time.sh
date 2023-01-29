#!/usr/bin/env sh

TIME=$(date '+%I:%M %p')

CLOCKICON=􀐫

sketchybar --set $NAME icon=$CLOCKICON label="$TIME"
