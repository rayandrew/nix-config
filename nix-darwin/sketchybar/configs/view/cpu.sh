#!/usr/bin/env sh

sketchybar -m --add item cpu right \
	--set cpu update_freq=3 \
	script="$PLUGIN_DIR/cpu.sh"
