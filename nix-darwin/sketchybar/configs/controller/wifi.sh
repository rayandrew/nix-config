#!/usr/bin/env bash

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
# CURR_IP="$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')"
CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"
CURR_NAME="$(echo "$CURRENT_WIFI" | awk '/ SSID:/ {print $2}')"
L=5
LENGTH_CURR="$(${#CURR_NAME} | wc -c)"

WIFIACTIVEICON=􀙇
WIFIINACTIVEICON=􀙈

if [[ $LENGTH_CURR -gt $L ]]; then
	CURR_NAME="${CURR_NAME::L}..."
fi

if [ "$CURR_TX" = "" ]; then
	sketchybar --set "$NAME" icon=$WIFIINACTIVEICON label=" |"
else
	sketchybar --set "$NAME" icon=$WIFIACTIVEICON label="${CURR_NAME} |"
fi
