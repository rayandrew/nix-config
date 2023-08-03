#!/usr/bin/env bash

file=$1
w=$2
h=$3
x=$4
y=$5
CACHE="$HOME/.cache/tmpimg"

if [[ "$(file -Lb --mime-type "$file")" =~ ^image ]]; then
	kitty +kitten icat --silent --stdin no --transfer-mode file --place "${w}x${h}@${x}x${y}" "$file" </dev/null >/dev/tty
	exit 1
fi

if [[ "$( file -Lb --mime-type "$file")" =~ ^application/pdf ]]; then
  pdftoppm -jpeg -f 1 -singlefile "$file" "$CACHE"
  kitty +kitten icat --silent --stdin no --transfer-mode file --place "${w}x${h}@${x}x${y}" "${CACHE}.jpg" </dev/null >/dev/tty
  exit 1
fi

pistol "$file"


# if file --mime "$1" | grep "executable" >/dev/null
# then
#     file -b "$1" | fold -sw "$2"
#     echo ""
#     (/usr/local/bin/checksec --file "$1" | fold -sw "$2") 2>&1 | tail -n +2
# else
#     case "$1" in
#         *.tar*) tar tf "$1";;
#         *.zip) unzip -l "$1";;
#         *.rar) unrar l "$1";;
#         *.7z) 7z l "$1";;
#         *.pdf) pdftotext "$1" -;;
#         # *.jpg) viu "$1";;
#         # *.jpeg) viu "$1";;
#         # *.png) viu "$1";;
#         *.jpg) kitty +kitten icat --silent --stdin no --transfer-mode file --place "${w}x${h}@${x}x${y}" "$file" </dev/null >/dev/tty;;
#         *.jpeg) kitty +kitten icat --silent --stdin no --transfer-mode file --place "${w}x${h}@${x}x${y}" "$file" </dev/null >/dev/tty;;
#         *.png) kitty +kitten icat --silent --stdin no --transfer-mode file --place "${w}x${h}@${x}x${y}" "$file" </dev/null >/dev/tty;;
#         *.doc) catdoc < "$1";;
#         *.docx) docx2txt < "$1";;
#         *) /bin/batcat --paging=never --terminal-width="$2" --color=always --theme=base16  "$1" | tail -n +3;;
#     esac
# fi

file=$1
# w=$2
# h=$3
# x=$4
# y=$5
# hfloat=$(expr $h*0.9 | bc)
# hint=${hfloat/.*}
# CACHE="$HOME/.cache/tmpimg"
#
# if [[ "$( file -Lb --mime-type "$file")" =~ ^image && $lf_preview == true ]]; then
#   kitty +icat --silent --transfer-mode file --place "${w}x${h}@${x}x2" "$file"
#   exit 1
# fi
#
# if [[ "$( file -Lb --mime-type "$file")" =~ ^application/pdf && $lf_preview == true ]]; then
#   pdftoppm -jpeg -f 1 -singlefile "$file" "$CACHE"
#   kitty +icat --silent --transfer-mode file --place "${w}x$hint@${x}x2" "${CACHE}.jpg"
#   exit 1
# fi
#
# cat "$file"
