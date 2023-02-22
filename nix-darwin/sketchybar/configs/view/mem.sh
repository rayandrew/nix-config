#!/usr/bin/env sh

sketchybar -m --add item ram right \
	--set ram update_freq=3 \
	script="$PLUGIN_DIR/mem.sh"
