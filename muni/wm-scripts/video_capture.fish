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
    set nid (notify-send -e -p -t 1100 -r $nid "Video capture started" "Use the same keyboard shortcut to stop. Recording starts in $i...")
    sleep 1
end

notify-send -e -t 100 -r $nid "Video capture started" "Recording now."

wf-recorder -f $folder/$date.mp4 && notify-send "Video capture stopped" "Your video was saved in $folder." || notify-send "Video capture failed" "Nothing was saved."
