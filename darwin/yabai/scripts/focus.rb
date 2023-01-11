# credits to @mvgijssel
# https://github.com/koekeishiya/yabai/issues/485#issuecomment-618682510

require 'fileutils'

FILE="/tmp/yabai_focus_tmp"
HISTORY_SIZE=10

action = ARGV[0]
value = ARGV[1]

def log(message)
  STDERR.puts message
end

def read_file
  !File.exist?(FILE) && FileUtils.touch(FILE)

  File.readlines(FILE).map do |item|
    item.strip
  end
end

# log "RUNNING `#{action}` - `#{value}`"

case action
when 'write'
  window_ids = read_file
  window_ids.unshift(value)

  window_ids = window_ids[0...HISTORY_SIZE]

  File.open(FILE, 'w+') do |f|
    f.puts(window_ids)
  end

  # log "new window ids: #{window_ids}"

when 'clear'
  File.delete(FILE)

when 'read'
  window_ids = read_file
  destroyed_window_id = value

  # log "reading window ids: `#{window_ids}`"
  # log "destroyed window id: `#{destroyed_window_id}`"

  # Get the index in the list where the destroyed window id is
  index_destroyed_window_id = window_ids.index(destroyed_window_id)

  # Only items after the destroyed window id are considered previous
  applicable_window_ids = window_ids[index_destroyed_window_id..]

  # log "applicable window ids: `#{applicable_window_ids}`"

  # Now search for the first window_id which is not the destroyed one
  previous_window_id = applicable_window_ids.find do |window_id|
    window_id != destroyed_window_id
  end

  # log "previous window id: `#{previous_window_id}`"

  puts previous_window_id
else
  raise "Unknown action `#{action}`"
end
