#!/usr/bin/env fish

set notification_id (dunstify -t 0 -p "Setting up desktop and mic capture..." "One moment...")

function cleanup
    echo "signal caught! stopping all jobs"
    kill -INT (jobs -p)
    kill -TERM (jobs -p)

    # execute post-capture hook
    ./post-capture.fish

    dunstctl set-paused false
    dunstify "Desktop and mic capture stopped" "Welcome back! Notifications are on again."
end

trap cleanup EXIT TERM INT QUIT

# make output folder
set date (date +%Y%m%d-%H%M%S)
set folder $HOME/Videos/Recordings/capture-$date/
mkdir -p $folder || exit

function prompt-mic-target
    pw-record --list-targets | tail -n +2 | while read line
        string match --regex '\d.*' $line
    end | bemenu -p 'Which is your mic?' | string match --regex '\d*'
end

# get mic target
dunstify -t 0 -r $notification_id "Setting up desktop and mic capture" "Waiting for you to select a mic..."
set mic_target (prompt-mic-target)

# get output geometry
dunstify -t 0 -r $notification_id "Setting up desktop and mic capture" "Select which output you want to record."
set output_geometry (slurp -o)

# open pipewire graph, just in case
dunstify -t 0 -r $notification_id "Setting up desktop and mic capture" "Opening PipeWire graph..."
qpwgraph &

dunstify -t 0 -r $notification_id "Ready to record" "Notifications will be paused. If everything looks good, have fun!"
set ready_response (echo -e "Yes\nCancel" | bemenu -p 'Ready to record?')
if test $ready_response != "Yes"
    cleanup
    dunstify -r $notification_id "Desktop and mic capture cancelled" "No problem!"
    exit
end

# execute pre-capture hook
./pre-capture.fish

# countdown
for i in (seq 5 -1 3)
    dunstify -r $notification_id "About to record" "Desktop and mic capture starts in $i..." &
    pw-play ./recording_countdown.ogg &
    sleep 1
end

# pause notifications
dunstify -C $notification_id &
dunstctl set-paused true &

# start recording screen and mic
kitty -T "Mic recording" arecord -D pipewire:NODE=$mic_target -f S32_LE -r 48000 -c 1 -V mono $folder/mic.wav &
kitty -T "Screen recording" wf-recorder -adesktop-audio-proxy -g"$output_geometry" -f"$folder/desktop.mp4" &

# finish countdown
pw-play ./recording_countdown.ogg &
sleep 1
pw-play ./recording_start.ogg &
sleep 1

# correct pipewire connections
pw-link -l -I | grep wf-recorder | while read line
    pw-link -d (string match -g --regex '\s*(\d*)\s.*\|' $line)
end
pw-link "desktop-audio-proxy:monitor_FL" (pw-link -i | string match -e --regex 'wf-recorder.*input_FL')
pw-link "desktop-audio-proxy:monitor_FR" (pw-link -i | string match -e --regex 'wf-recorder.*input_FR')

wait
