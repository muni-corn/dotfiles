#! /usr/bin/env fish

if pgrep -x wf-recorder >/dev/null
    pkill --signal SIGINT wf-recorder
    exit
end

set date (date +%s)

set folder $HOME/Videos/Recordings
mkdir -p $folder

set nid -1
for i in (seq 5 -1 1)
    set nid (dunstify -p -r $nid "Video capture started" "Use the same keyboard shortcut to stop. Recording starts in $i...")
    sleep 1
end

dunstify -C $nid

wf-recorder -f $folder/$date.mp4 && dunstify "Video capture stopped" "Your video was saved in $folder." || dunstify "Video capture failed" "Nothing was saved."
