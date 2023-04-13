#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh" # Loads all defined colors
source "$CONFIG_DIR/icons.sh"  # Loads all defined icons

# PADDING=4
# ICON="Liga SFMono Nerd Font"
# LABEL="Liga SFMono Nerd Font"
FONT="SF Pro" # Needs to have Regular, Bold, Semibold, Heavy and Black variants
PADDINGS=3    # All paddings use this value (icon, label, background)

# read yabai spaces
# declare -a SPACES
# while read -r index name; do
# 	SPACES[$index]="$name"
# done <"{{ yabai_spaces_file }}"

# Setting up and starting the helper process
killall "{{ helper }}"
"{{ helper }}" $HELPER >/dev/null 2>&1 &

## Unload the macOS on screen indicator overlay for volume change
launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist >/dev/null 2>&1 &

bar=(
	height=45
	color=$BAR_COLOR
	border_width=2
	border_color=$BAR_BORDER_COLOR
	shadow=off
	position=top
	sticky=on
	padding_right=10
	padding_left=10
	y_offset=-5
	margin=-2
)

sketchybar --bar "${bar[@]}"

# Setting up default values
defaults=(
	updates=when_shown
	icon.font="$FONT:Bold:14.0"
	icon.color=$ICON_COLOR
	icon.padding_left=$PADDINGS
	icon.padding_right=$PADDINGS
	label.font="$FONT:Semibold:13.0"
	label.color=$LABEL_COLOR
	label.padding_left=$PADDINGS
	label.padding_right=$PADDINGS
	padding_right=$PADDINGS
	padding_left=$PADDINGS
	background.height=26
	background.corner_radius=9
	background.border_width=2
	popup.background.border_width=2
	popup.background.corner_radius=9
	popup.background.border_color=$POPUP_BORDER_COLOR
	popup.background.color=$POPUP_BACKGROUND_COLOR
	popup.blur_radius=20
	popup.background.shadow.drawing=on
)

sketchybar --default "${defaults[@]}"

# Left
source "$ITEMS_DIR/apple.sh"
source "$ITEMS_DIR/space.sh"
source "$ITEMS_DIR/front_app.sh"

# center
source "$ITEMS_DIR/spotify.sh"

# right
source "$ITEMS_DIR/calendar.sh"
source "$ITEMS_DIR/battery.sh"
source "$ITEMS_DIR/volume.sh"
source "$ITEMS_DIR/cpu.sh"

# Forcing all item scripts to run (never do this outside of sketchybarrc)
sketchybar --update

echo "sketchybar configuation loaded.."
