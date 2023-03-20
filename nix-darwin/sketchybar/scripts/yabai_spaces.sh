#!/usr/bin/env bash

declare -A SPACE_ICONS
SPACE_ICONS["web"]="􀤆"
SPACE_ICONS["main"]="􀎞"
SPACE_ICONS["code"]="􀈊"
SPACE_ICONS["mail"]="􀍕"
SPACE_ICONS["note"]="􀓕"
SPACE_ICONS["social"]="􀌨"
SPACE_ICONS["commands"]="􀆔"

icons=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
highlight_colors=("" "0xff9dd274" "0xfff69c5e" "0xff72cce8" "0xffeacb64" "0xff9dd274" "0xfff69c5e" "0xff72cce8" "0xffeacb64" "0xff9dd274" "0xfff69c5e" "0xff72cce8" "0xffeacb64" "0xff9dd274" "0xfff69c5e")

args=()
QUERY="$(yabai -m query --spaces | jq -r '.[] | [.index, .windows[0], .label, .display, ."is-visible", ."is-native-fullscreen"] | @sh')"

NAMES=""
while read -r index window yabai_name display visible fullscreen; do
	if [ "$fullscreen" = "true" ]; then
		continue
	fi
	# echo "$index $window $yabai_name $display $visible"
	NAME="$(echo "${yabai_name}" | tr -d "'")"
	if [ "${window}" = "null" ]; then
		label="$NAME"
	else
		label="$NAME*"
	fi
	if [ "$NAME" = "" ] || [ "$NAME" = " " ]; then
		NAME="${index}"
	fi

	icon="${icons[${index}]}"
	if [[ -v SPACE_ICONS["$NAME"] ]]; then
		icon="${SPACE_ICONS["$NAME"]}"
	fi

	NAMES="$NAMES $NAME"
	args+=(--clone "$NAME" space_template after
		--set "$NAME" label="${label}"
		label.highlight_color="${highlight_colors[${index}]}"
		label.highlight="$visible"
		icon="${icon}"
		icon.highlight_color="${highlight_colors[${index}]}"
		associated_display="$display"
		icon.highlight="$visible"
		drawing=on)
done <<<"$QUERY"

args+=(--reorder "$NAMES")
sketchybar -m ${args[@]} &>/dev/null
