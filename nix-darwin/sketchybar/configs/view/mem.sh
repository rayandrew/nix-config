#!/usr/bin/env sh

sketchybar -m --add item ram right                         \
              --set ram update_freq=1                      \
                    script="$PLUGIN_DIR/mem.sh"        \
