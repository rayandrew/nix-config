#!/usr/bin/env bash

PERCENTAGE=$(pmset -g batt | grep -Po "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
	exit 0
fi

case ${PERCENTAGE} in
[8-9][0-9] | 100)
	ICON=􀛨
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%" icon.color="$FOREGROUND" label.color="$FOREGROUND"
	;;
[7-8][0-9])
	ICON=􀺸
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%" icon.color="$FOREGROUND" label.color="$FOREGROUND"
	;;
[3-7][0-9])
	ICON=􀺶
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%" icon.color="$FOREGROUND" label.color="$FOREGROUND"
	;;
[1-3][0-9])
	ICON=􀛩
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%" icon.color="0xffFEDE00" label.color="0xffFEDE00"
	;;
[0-1][0-9])
	ICON=􀛪
	sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%" icon.color="0xffDC0000" label.color="0xffDC0000"
	;;
esac

if [[ "$CHARGING" != "" ]]; then
	case ${PERCENTAGE} in
	[0-9][0-9] | 100)
		ICON=􀢋
		sketchybar --set "$NAME" icon=$ICON label="${PERCENTAGE}%" icon.color="0xff31d157" label.color="0xff31d157"
		;;
	esac
fi
