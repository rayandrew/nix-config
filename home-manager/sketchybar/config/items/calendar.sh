#!/usr/bin/env bash

calendar=(
	icon=cal
	icon.font="$FONT:Black:12.0"
	icon.padding_right=0
	label.width=45
	label.align=right
	padding_left=15
	update_freq=30
	script="$SCRIPTS_DIR/calendar.sh"
	click_script="$SCRIPTS_DIR/zen.sh"
)

sketchybar --add item calendar right \
	--set calendar "${calendar[@]}" \
	--subscribe calendar system_woke
