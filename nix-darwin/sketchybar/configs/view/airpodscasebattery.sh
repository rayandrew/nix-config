#!/usr/bin/env sh

sketchybar --add item airpodscase right                                   \
w          --set      airpodscase update_freq=5                            \
                      script="$PLUGIN_DIR/airpodscasebattery.sh"          \
