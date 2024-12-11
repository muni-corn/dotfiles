#! /usr/bin/env fish

## hypr-screenshot.fish ##
## takes screenshots for hyprland
## requires notify-send for nice notifications

function kill_hyprpicker
    if set -q picker_pid
        kill $picker_pid
    end
end

function check_cancellation
    set slurp_status $status
    if test $slurp_status -ne 0
        kill_hyprpicker
        notify-send -a Capture "$type cancelled" "No problem!"
        exit $slurp_status
    end
end

function launch_hyprpicker
    hyprpicker -r -z &
    set -g picker_pid $last_pid
    sleep 0.3
end

# format the current time for the screenshot file
set date (date +%Y%m%d-%H%M%S)

# make screnshot folder, if needed
set folder $HOME/Pictures/Screenshots
if ! test -d $folder
    mkdir -p $folder
end

if test "$argv[1]" = -s
    set type "Selection screenshot"
    set name $folder/$date-s.png

    # get window regions
    set workspaces (hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')
    set windows (hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))')

    # freeze screen and get region to capture
    launch_hyprpicker
    set region (echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)
    check_cancellation

    # snap! and get status
    sleep 0.3s
    grim -g $region $name
else if test "$argv[1]" = -o
    set type "Display screenshot"
    set name $folder/$date-o.png

    # freeze screen and get region to capture
    launch_hyprpicker
    set region (slurp -o)
    check_cancellation

    # snap! and get status
    sleep 0.3s
    grim -g $region $name
else
    set type "Full screenshot"
    set name $folder/$date.png

    # snap! and get status
    grim $name
end

if test $status -eq 0
    wl-copy <$name
    and notify-send -a Capture "$type saved and copied" "Your capture was saved as $name."
    or notify-send -a Capture "$type saved" "Your capture was saved as $name."
else
    notify-send -a Capture "$type failed" "There was an error, so nothing was saved. Sorry. :("
end

kill_hyprpicker
