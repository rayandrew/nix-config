#!/usr/bin/env bash

# Color Palette
export BLACK=0xff181926
export WHITE=0xffcad3f5
export RED=0xffff8182
export GREEN=0xff4ac26b
export BLUE=0xff54aeff
export YELLOW=0xfff5a97f
export ORANGE=0xffed8796
export MAGENTA=0xffc297ff
export GREY=0xff8c959f
export TRANSPARENT=0x00000000

# General bar colors
# export BAR_COLOR=0xff1e1e2e
export BAR_COLOR=$BACKGROUND
# export BAR_BORDER_COLOR=0xff494d64 #0xa024273a
export BAR_BORDER_COLOR=$FOREGROUND #0xa024273a
# export ICON_COLOR=$WHITE            # Color of all icons
# export LABEL_COLOR=$WHITE           # Color of all labels
export ICON_COLOR=$FOREGROUND  # Color of all icons
export LABEL_COLOR=$FOREGROUND # Color of all labels
# export BACKGROUND_1=0x603c3e4f
# export BACKGROUND_2=0x60494d64

export BACKGROUND_1=0xfff4f7fa
export BACKGROUND_2=0xffe1e4e8

export POPUP_BACKGROUND_COLOR=$BACKGROUND
export POPUP_BORDER_COLOR=$FOREGROUND

export SHADOW_COLOR=$BLACK
