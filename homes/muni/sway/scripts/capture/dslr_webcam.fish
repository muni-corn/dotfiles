#!/usr/bin/env fish

set notification_id (dunstify -t 0 -p "Setting up DSLR capture..." "One moment...")

function cleanup
    echo "signal caught! stopping all jobs"
    kill -INT (jobs -p)
    kill -TERM (jobs -p)

    # reset dslr, just in case
    gphoto2 --reset

    dunstify "DSLR capture stopped" "Your recording was saved."
end

trap cleanup EXIT TERM INT QUIT

# make output folder
set date (date +%Y%m%d-%H%M%S)
set folder $HOME/Videos/Recordings/capture-$date/
mkdir -p $folder || exit

# start dslr webcam
dunstify -t 0 -r $notification_id "Setting up DSLR capture" "Starting DSLR webcam stream..."
kitty -T "Gphoto stream" ./dslr_stream.fish &

dunstify -t 0 -r $notification_id "Ready to record" "DSLR capture setup is complete!"
set ready_response (echo -e "Yes\nCancel" | bemenu -p 'Ready to record?')
if test $ready_response != "Yes"
    cleanup
    dunstify -r $notification_id "DSLR capture cancelled" "No problem!"
    exit
end

# start recording webcam
dunstify -C $notification_id
kitty -T "Webcam recording" ffmpeg -i /dev/video0 -vcodec libx264 -preset veryfast -tune film $folder/webcam.mp4 &

# start video monitor
ffplay /dev/video0 > /dev/null &

echo "Waiting for all jobs to stop..."
wait
