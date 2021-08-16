#! /usr/bin/env fish

#####################
## screenshot.fish ##
#####################
## takes screenshots with sway. requires dunstify for nice notifications

# format the current time for the screenshot file
set date (date +%Y%m%d-%H%M%S)

# make screnshot folder, if needed
set folder $HOME/Pictures/Screenshots
if ! test -d $folder
    mkdir -p $folder
end

if test "$argv[1]" = "-s"
    set name $folder/$date-s.png

    # get initial notification id, so we can dismiss it right before we capture
    set nid (dunstify -p "Selection screenshot started" "Select a window or area to capture.")

    # get region to capture
    set region (swaymsg -t get_tree | \
        jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | \
        slurp)

    # get status to see if selection was cancelled
    set slurp_status $status
    if test $slurp_status -ne 0
        dunstify -r $nid "Screenshot cancelled" "No problem!"
        exit $slurp_status
    end

    # close notification before capturing
    dunstify -C $nid

    # snap!
    grim -g $region $name && \
        dunstify -r $nid "Screenshot saved" "Your capture was saved as $name." || \
        dunstify -r $nid "Screenshot failed" "There was an error, so nothing was saved. Sorry. :("

else if test "$argv[1]" = "-o"
    set name $folder/$date-o.png
    # get initial notification id, so we can dismiss it right before we capture
    set nid (dunstify -p "Display screenshot started" "Select a display to capture.")

    # get region to capture
    set region (slurp -o)

    # get status to see if selection was cancelled
    set slurp_status $status
    if test $slurp_status -ne 0
        dunstify -r $nid"Screenshot cancelled" "No problem!"
        exit $slurp_status
    end

    # close notification before capturing
    dunstify -C $nid

    # snap!
    grim -g $region $name && \
        dunstify -r $nid "Screenshot saved" "Your capture was saved as $name." || \
        dunstify -r $nid "Screenshot failed" "There was an error, so nothing was saved. Sorry. :("
else
    set name $folder/$date.png
    grim $name && \
        dunstify "Full screenshot taken" "Your capture was saved as $name." || \
        dunstify "Screenshot failed" "There was an error, so nothing was saved. Sorry. :("
end
