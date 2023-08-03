#!/usr/bin/env bash


CACHE="$HOME/.cache/tmpimg"
[ -f "${CACHE}.jpg" ] && rm "${CACHE}.jpg"
kitty +kitten icat --clear --stdin no --silent --transfer-mode file </dev/null >/dev/tty
