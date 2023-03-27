#!/usr/bin/env bash

sketchybar --set "$NAME" \
	label.highlight="$SELECTED" \
	icon.highlight="$SELECTED"

# if [[ "$SELECTED" == "true" ]]; then
#   sketchybar --set "$NAME" \
#     icon.color="$BACKGROUND" \
#     label.color="$BACKGROUND"
# else
#   sketchybar --set "$NAME" \
#     icon.color="$FOREGROUND" \
#     label.color="$FOREGROUND"
# fi
