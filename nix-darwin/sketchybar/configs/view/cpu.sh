#!/usr/bin/env sh

sketchybar -m --add item cpu right                         \
              --set cpu update_freq=1                      \
                    script="$PLUGIN_DIR/cpu.sh"        \

