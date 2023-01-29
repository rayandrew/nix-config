#!/usr/bin/env sh

sketchybar --add item airpods right                                \
           --set      airpods update_freq=5                        \
                      script="$PLUGIN_DIR/airpodsbattery.sh"       \
