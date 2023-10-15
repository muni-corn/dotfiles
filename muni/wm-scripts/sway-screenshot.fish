#! /usr/bin/env fish

## sway-screenshot.fish ##
## takes screenshots for sway. requires dunstify for nice notifications

# format the current time for the screenshot file
set date (date +%Y%m%d-%H%M%S)

# make screnshot folder, if needed
set folder $HOME/Pictures/Screenshots
if ! test -d $folder
    mkdir -p $folder
end

if test "$argv[1]" = "-s"
    set type "Selection screenshot"
    set name $folder/$date-s.png

    # get initial notification id, so we can dismiss it right before we capture
    set nid (dunstify -p "$type started" "Select a window or area to capture.")

    # get region to capture
    set region (swaymsg -t get_tree | \
        jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | \
        slurp)

    # get status to see if selection was cancelled
    set slurp_status $status
    if test $slurp_status -ne 0
        dunstify -r $nid "$type cancelled" "No problem!"
        exit $slurp_status
    end

    # close notification before capturing
    dunstify -C $nid

    # snap! and get status
    grim -g $region $name
    set grim_status $status
else if test "$argv[1]" = "-o"
    set type "Display screenshot"
    set name $folder/$date-o.png
    # get initial notification id, so we can dismiss it right before we capture
    set nid (dunstify -p "$type started" "Select a display to capture.")

    # get region to capture
    set region (slurp -o)

    # get status to see if selection was cancelled
    set slurp_status $status
    if test $slurp_status -ne 0
        dunstify -r $nid "$type cancelled" "No problem!"
        exit $slurp_status
    end

    # close notification before capturing
    dunstify -C $nid

    # snap! and get status
    grim -g $region $name
    set grim_status $status
else
    set type "Full screenshot"
    set name $folder/$date.png

    # snap! and get status
    grim $name
    set grim_status $status
end


if test $grim_status -eq 0
    wl-copy < $name
    and dunstify "$type saved and copied" "Your capture was saved as $name."
    or dunstify "$type saved" "Your capture was saved as $name."
else
    dunstify "$type failed" "There was an error, so nothing was saved. Sorry. :("
end
