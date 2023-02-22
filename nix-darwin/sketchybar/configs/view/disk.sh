#!/usr/bin/env sh

sketchybar --add item disk right \
	--set disk script="$PLUGIN_DIR/disk.sh" \
	update_freq=5
