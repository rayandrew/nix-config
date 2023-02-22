#!/usr/bin/env sh

sketchybar -m --add item mic right \
	--set mic update_freq=1 \
	script="$PLUGIN_DIR/mic.sh" \
	click_script="$PLUGIN_TOUCH/mic.sh"
