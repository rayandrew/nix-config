#!/usr/bin/env bash

PERCENTAGE=$(pmset -g batt | grep -Po "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
	exit 0
fi

case ${PERCENTAGE} in
[8-9][0-9] | 100)
	ICON=􀛨
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%"
	;;
[7-8][0-9])
	ICON=􀺸
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%"
	;;
[3-7][0-9])
	ICON=􀺶
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%"
	;;
[1-3][0-9])
	ICON=􀛩
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%"
	;;
[0-1][0-9])
	ICON=􀛪
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%"
	;;
esac

if [[ "$CHARGING" != "" ]]; then
	case ${PERCENTAGE} in
	[0-9][0-9] | 100)
		ICON=􀢋
		sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%"
		;;
	esac
fi
