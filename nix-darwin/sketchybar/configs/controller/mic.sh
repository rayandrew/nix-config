#!/usr/bin/env sh

MIC_VOLUME=$(osascript -e 'input volume of (get volume settings)')

MICONICON=􀊰
MICOFICON=􀊲

if [[ $MIC_VOLUME == 'missing value' || $MIC_VOLUME -eq 0 ]]; then
	sketchybar -m --set mic icon=$MICOFICON label="off |"
elif [[ $MIC_VOLUME -gt 0 ]]; then
	sketchybar -m --set mic icon=$MICONICON label="on |"
fi
