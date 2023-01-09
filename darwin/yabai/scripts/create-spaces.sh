#!/bin/sh

echo "Creating spaces..."

DESIRED_SPACES_PER_DISPLAY=10
CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"
NUM_OF_DISPLAYS="$(yabai -m query --displays | jq -r '. | length')"

# echo "$NUM_OF_DISPLAYS"
# if [ "$NUM_OF_DISPLAYS" -gt 1 ]; then
#   IDS="$(yabai -m query --displays | jq -r '.[].id | @sh')"
#   for i in $IDS
#   do
#     echo $i
#   done
#   exit 0
# fi
#
# echo $IDS

DELTA=0
while read -r line
do
  LAST_SPACE="$(echo "${line##* }")"
  LAST_SPACE=$((LAST_SPACE+DELTA))
  EXISTING_SPACE_COUNT="$(echo "$line" | wc -w)"
  MISSING_SPACES=$((DESIRED_SPACES_PER_DISPLAY - EXISTING_SPACE_COUNT))
  # echo "ELLO $line | $EXISTING_SPACE_COUNT | $MISSING_SPACES"
  if [ "$MISSING_SPACES" -gt 0 ]; then
    for i in $(seq 1 $MISSING_SPACES)
    do
      yabai -m space --create "$LAST_SPACE"
      LAST_SPACE=$((LAST_SPACE+1))
    done
  elif [ "$MISSING_SPACES" -lt 0 ]; then
    for i in $(seq 1 $((-MISSING_SPACES)))
    do
      yabai -m space --destroy "$LAST_SPACE"
      LAST_SPACE=$((LAST_SPACE-1))
    done
  fi
  DELTA=$((DELTA+MISSING_SPACES))
done <<< "$CURRENT_SPACES"

sketchybar --trigger space_change
