#!/bin/sh

isFocused=$(yabai -m query --windows --window | jq -re ".id")
if [[ -z "$isFocused" ]]; then # -z >> true if it's null
	$(yabai -m window --focus $(yabai -m query --windows | jq -re ".[] | select((.visible == 1) and .focused != 1).id" | head -n 1))
fi
