#!/usr/bin/env bash

CURRENT_SPACE_IDX=$(yabai -m query --spaces --space | jq '.index')
NOTE_SPACE_IDX=$(yabai -m query --spaces | jq '.[] | select(.label | contains("note")) | .index')

if [ "$CURRENT_SPACE_IDX" != "$NOTE_SPACE_IDX" ]; then
	# echo "Not splitting non-note space, should be space=$NOTE_SPACE_IDX, but got=$CURRENT_SPACE_IDX"
	exit 0
fi

# taken from https://github.com/koekeishiya/yabai/issues/855
# CURRENT_DISPLAY=$(yabai -m query --windows --window | jq '.display')
# WINDOWS_ARRAY=$(yabai -m query --windows --space $(yabai -m query --spaces --space | jq '.index') --display $CURRENT_DISPLAY | jq -r 'map(select(.["is-minimized"]==false and .["is-floating"]==false))')
# WINDOWS_ARRAY=$(yabai -m query --windows --space $NOTE_SPACE_IDX --display $CURRENT_DISPLAY | jq -r 'map(select(.["is-minimized"]==false and .["is-floating"]==false))')
# NUMBER_OF_WINDOWS=$(echo $WINDOWS_ARRAY | jq -r 'length')

# case $NUMBER_OF_WINDOWS in
# [0-1])
# 	# yabai -m config split_ratio 0.65
# 	yabai -m config split_type auto
# 	;;
# 2)
# 	# yabai -m config split_ratio 0.5
# 	;;
# 3)
# 	yabai -m config split_ratio 0.5
# 	yabai -m space --balance x-axis
# 	yabai -m config split_type horizontal
# 	;;
# *)
# 	yabai -m space --balance x-axis
# 	;;
# esac

# yabai -m config split_ratio 0.5
yabai -m config split_type vertical
yabai -m space --balance

# case $NUMBER_OF_WINDOWS in
# [0-1])
#   yabai -m config split_type auto
# 	;;
# *)
# 	yabai -m config split_ratio 0.5
# 	yabai -m space --balance x-axis
# 	yabai -m config split_type vertical
# 	;;
# esac
