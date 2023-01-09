#!/usr/bin/env sh

# source "$HOME/.config/sketchybar/icons.sh"
PERCENTAGE=$(pmset -g batt | grep -Po "\d+%" | cut -d% -f1)
# pmset -g batt | grep -Eo "[0-9]*%" # gnu grep or
# pmset -g batt | grep -Po "\d+%" # gnu grep or
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
	exit 0
fi

case ${PERCENTAGE} in
9[0-9] | 100)
	ICON=$BATTERY_FULL
	;;
[6-8][0-9])
	ICON=$BATTERY_75
	;;
[3-5][0-9])
	ICON=$BATTERY_50
	;;
[1-2][0-9])
	ICON=$BATTERY_25
	;;
*) ICON=$BATTERY_0 ;;
esac

if [[ $CHARGING != "" ]]; then
	ICON=$BATTERY_CHARGING
fi

sketchybar --set power_logo icon="$ICON" \
	--set battery label="${PERCENTAGE}%"
