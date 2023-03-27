#!/usr/bin/env bash

## Unload the macOS on screen indicator overlay for volume change
launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist >/dev/null 2>&1 &

PADDING=4
ICON="Liga SFMono Nerd Font"
LABEL="Liga SFMono Nerd Font"

# read yabai spaces
declare -a SPACES
while read -r index name; do
	SPACES[$index]="$name"
done </tmp/yabai-spaces

function add_separator() {
	local id=$1
	local pos=$2
	sketchybar --add item "$id" "$pos" \
		--set "$id" icon= \
		icon.padding_left=0 \
		icon.padding_right=0 \
		background.padding_left=0 \
		background.padding_right=0 \
		icon.align=center
}

sketchybar -m --add event window_created \
	--add event window_destroyed

sketchybar --bar height="{{ barSize }}" \
	blur_radius=0 \
	color="0xff{{ barBackground }}" \
	position=top \
	sticky=on \
	font_smoothing=on \
	--default updates=when_shown \
	drawing=on \
	icon.padding_left=$PADDING \
	icon.padding_right=$PADDING \
	label.padding_left=$PADDING \
	label.padding_right=$PADDING \
	icon.font="$ICON:Bold:{{ fontSize }}.0" \
	label.font="$LABEL:Regular:{{ fontSize }}.0" \
	label.color="0xff{{ barForeground }}" \
	icon.color="0xff{{ barForeground }}"

# sketchybar -m --add item yabai_spaces left \
# 	--set yabai_spaces drawing=off \
# 	updates=on \
# 	script="{{ scripts }}/yabai_spaces.sh" \
# 	--subscribe yabai_spaces space_change window_created window_destroyed \
# 	--add item space_template left \
# 	--set space_template icon.highlight_color=0xff9dd274 \
# 	drawing=off \
# 	click_script="yabai -m space --focus \$NAME"

SPACE_ICONS=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "z")
HIGHLIGHT_COLORS=("0xff9dd274" "0xfff69c5e" "0xff72cce8" "0xffeacb64" "0xff9dd274" "0xfff69c5e" "0xff72cce8" "0xffeacb64" "0xff9dd274" "0xfff69c5e" "0xff72cce8" "0xffeacb64" "0xff9dd274" "0xfff69c5e")

for i in "${!SPACE_ICONS[@]}"; do
	sid=$((i + 1))
	idx=$i

	label=""
	if [[ "${SPACES[$sid]+isset}" ]]; then
		label="${SPACES[$sid]}"
	fi

	sketchybar --add space space.$sid left \
		--set space.$sid associated_space=$sid \
		ignore_association=off \
		icon="${SPACE_ICONS[$idx]}" \
		icon.highlight_color="${HIGHLIGHT_COLORS[$idx]}" \
		label="$label" \
		label.drawing="on" \
		label.highlight_color="${HIGHLIGHT_COLORS[$idx]}" \
		script="{{ scripts }}/space.sh" \
		click_script="yabai -m space --focus $sid" \
		padding_left=2 \
		padding_right=2 \
		drawing=on
done

sketchybar --add item time right \
	--set time update_freq=5 \
	icon.drawing=off \
	script="{{ scripts }}/time.sh"

add_separator "sep_right_0" "right"

sketchybar --add item battery right \
	--subscribe battery system_woke \
	--set battery update_freq=5 \
	script="{{ scripts }}/battery.sh"

add_separator "sep_right_1" "right"

sketchybar -m --add item cpu right \
	--set cpu update_freq=3 \
	script="{{ scripts }}/cpu.sh"

add_separator "sep_right_2" "right"

sketchybar -m --add item disk right \
	--set disk update_freq=10 \
	script="{{ scripts }}/disk.sh"

add_separator "sep_right_3" "right"

sketchybar -m --add item ram right \
	--set ram update_freq=5 \
	script="{{ scripts }}/mem.sh"

add_separator "sep_right_4" "right"

# Title
sketchybar --add item window_title right \
	--set window_title script="{{ scripts }}/window_title.sh" \
	icon.drawing=off \
	label.color="0xff{{barForeground}}" \
	--subscribe window_title front_app_switched

# initializing
sketchybar --update
