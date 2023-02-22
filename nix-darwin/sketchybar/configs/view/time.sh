#!/usr/bin/env sh

sketchybar --add item time right \
	--set time update_freq=5 \
	script="$PLUGIN_DIR/time.sh"
