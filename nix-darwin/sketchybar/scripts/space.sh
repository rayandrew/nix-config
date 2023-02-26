#!/usr/bin/env bash

if [[ "$SELECTED" == "true" ]]; then
	sketchybar --set "$NAME" background.drawing="on" \
		background.color="$FOREGROUND" \
		icon.color="$BACKGROUND"
else
	sketchybar --set "$NAME" background.drawing="off" \
		background.color="$BACKGROUND" \
		icon.color="$FOREGROUND"
fi
