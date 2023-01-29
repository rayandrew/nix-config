#!/usr/bin/env sh

VOLUME=$(osascript -e "output volume of (get volume settings)")
MUTED=$(osascript -e "output muted of (get volume settings)")

SOUNDACTIVEICON=􀊨
SOUNDINACTIVEICON=􀊢

if [[ $MUTED != "false" ]]; then
	sketchybar --set $NAME icon=$SOUNDINACTIVEICON label="$VOLUME% |"
else
	sketchybar --set $NAME icon=$SOUNDACTIVEICON label="$VOLUME% |"
fi
