#!/usr/bin/env bash

# inspired from https://gist.github.com/mickaelperrin/4b72fa46dec0aa8935b170685dac507d
# https://github.com/aiguofer/dotfiles/blob/master/user/.local/bin/yabaict

SPACES_FILE="/tmp/yabai-spaces"

UUID_MIDNIGHT="37D8832A-2D66-02CA-B9F7-8F30A301B230"
UUID_VP229="9E041B4A-1854-4D12-9822-F9B494EA5AFF"
UUID_APPLE_STUDIO="3E3DA20F-B1F1-4506-AA57-C97148A2A31D"

DISPLAYS=$(yabai -m query --displays)
MONITORS=$(echo "$DISPLAYS" | jq '.[].index')

debug() {
	echo "$@" 1>&2
}

delete_all_spaces() {
	for monitor in ${MONITORS[@]}; do
		local FOCUS_SPACE=$(yabai -m query --spaces --display $monitor | jq '.[0].index')
		# debug "Focusing space $FOCUS_SPACE"
		yabai -m space --focus "$FOCUS_SPACE"
		while [ $(yabai -m query --spaces --display $monitor | jq '. | length') -ne 1 ]; do
			local SPACE_ID=$(yabai -m query --spaces --display $monitor | jq '.[-1].index')
			# debug "Deleting space $SPACE_ID"
			yabai -m space --destroy "$SPACE_ID"
		done
	done
	touch $SPACES_FILE
	truncate -s 0 $SPACES_FILE
}

name_first_space() {
	local monitor="$1"
	local label="$2"
	shift
	shift
	local SPACE_ID
	SPACE_ID=$(get_first_space_of_monitor "$monitor")
	# debug "Name space ($SPACE_ID): $2"
	yabai -m space "$SPACE_ID" --label "$label" "$@"
	echo "$SPACE_ID" "$label" >>$SPACES_FILE
}

name_space() {
	local monitor="$1"
	local label="$2"
	shift
	shift
	local SPACE_ID
	SPACE_ID=$(yabai -m query --spaces --display "$monitor" | jq '[.[] | select (.label=="")] | .[0] | .index')
	# debug "Name space ($SPACE_ID): $2"
	yabai -m space "$SPACE_ID" --label "$label" "$@"
	echo "$SPACE_ID" "$label" >>$SPACES_FILE
}

get_first_space_of_monitor() {
	yabai -m query --spaces --display "$1" | jq '.[0].index'
}

create_space_on_monitor() {
	local monitor="$1"
	local label="$2"
	shift
	shift
	local FIRST_SPACE
	FIRST_SPACE=$(get_first_space_of_monitor "$monitor")
	# debug "Create space after $FIRST_SPACE"
	yabai -m space --create "$FIRST_SPACE"
	name_space "$monitor" "$label" "$@"
}

delete_all_spaces

MIDNIGHT=$(echo "$DISPLAYS" | jq --arg UUID "$UUID_MIDNIGHT" '.[] | select(.uuid == $UUID)') # guaranteed
MIDNIGHT_INDEX=$(echo "$MIDNIGHT" | jq '.index')

VP229=$(echo "$DISPLAYS" | jq --arg UUID "$UUID_VP229" '.[] | select(.uuid == $UUID)')
APPLE_STUDIO=$(echo "$DISPLAYS" | jq --arg UUID "$UUID_APPLE_STUDIO" '.[] | select(.uuid == $UUID)')
if [ -n "$VP229" ]; then
	# VP229 CONNECTED

	## VP229
	VP229_INDEX=$(echo "$VP229" | jq '.index')
	name_first_space "$VP229_INDEX" "web"
	create_space_on_monitor "$VP229_INDEX" "main"
	create_space_on_monitor "$VP229_INDEX" "code"
	create_space_on_monitor "$VP229_INDEX" "note" --layout stack
	create_space_on_monitor "$VP229_INDEX" "mail"
	create_space_on_monitor "$VP229_INDEX" "chat"

	# midnight
	# name_first_space "$MIDNIGHT_INDEX" "web"
	# create_space_on_monitor "$MIDNIGHT_INDEX" "commands"
	name_first_space "$MIDNIGHT_INDEX" "commands"
elif [ -n "$APPLE_STUDIO" ]; then
	# APPLE_STUDIO CONNECTED

	## APPLE_STUDIO
	APPLE_STUDIO_INDEX=$(echo "$APPLE_STUDIO" | jq '.index')
	name_first_space "$APPLE_STUDIO_INDEX" "web"
	create_space_on_monitor "$APPLE_STUDIO_INDEX" "main"
	create_space_on_monitor "$APPLE_STUDIO_INDEX" "code"
	create_space_on_monitor "$APPLE_STUDIO_INDEX" "note" --layout stack
	create_space_on_monitor "$APPLE_STUDIO_INDEX" "mail"
	create_space_on_monitor "$APPLE_STUDIO_INDEX" "chat"

	# midnight
	name_first_space "$MIDNIGHT_INDEX" "commands"
fi

yabai -m space --focus 1 # focus main display

## Organizing apps

# Do not manage some apps which are not resizable
yabai -m rule --add app="^(LuLu|Vimac|Calculator|VLC|System Settings|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice)$" manage=off
yabai -m rule --add label="raycast" app="^Raycast$" manage=off
yabai -m rule --add label="1Password" app="^1Password$" manage=off
yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy Report|Advance)$" manage=off
yabai -m rule --add label="System Settings" app="^System Preferences$" manage=off
yabai -m rule --add label="App Store" app="^App Store$" manage=off
yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
yabai -m rule --add label="Software Update" title="Software Update" manage=off
yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
yabai -m rule --add app="^IntelliJ IDEA$" manage=off
yabai -m rule --add app="^coreautha$" manage=off # 1Password biometric
yabai -m rule --add app="^Installer$" manage=off
yabai -m rule --add app="^Cisco AnyConnect Secure Mobility Client$" layer=above manage=off
yabai -m rule --add label="Orion" app="^Orion$" title="^(General|Appearance|Browsing|Sync|Passwords|Privacy|Search|Websites)$" manage=off
yabai -m rule --add label="Arc" app="^Arc$" title="^(Account|General|Shortcuts|Little Arc|Previews|Updates|Archive|Site Settings|Advanced)$" manage=off
yabai -m rule --add label="Desmume" app="^DeSmuME$" manage=off

yabai -m rule --add app="^Finder$" sticky=on manage=off # layer=above
# yabai -m rule --add app="^(Neovide|Notion)$" manage=on space=3 # for note-taking
# yabai -m rule --add app="^Linear$" space=3
yabai -m rule --add label="Zotero" app="^Zotero$" manage=on space="^note"
yabai -m rule --add label="Zotero Utils" app="^Zotero$" title="^(Find Available PDFs|General|Sync|Search|Export|Cite|Advanced)$" manage=off
yabai -m rule --add app="^Focused Work$" manage=off
yabai -m rule --add label="Emacs" app="^(Emacs|emacs|emacsclient)$" manage=on space="^note"
yabai -m rule --add app="^(Mail|Calendar|Fantastical|Spark Desktop)$" space="^mail"
yabai -m rule --add label="Communication" app="^(Skype|Slack|Discord)$" space="^chat"
yabai -m rule --add app="^(Google Chrome|Firefox|Safari|Orion|Arc|Microsoft Edge)$" space="^web"
# yabai -m rule --add label="Little Arc" app="^Arc$" title="^Space.*" manage=off # for Little Arc to be happy
