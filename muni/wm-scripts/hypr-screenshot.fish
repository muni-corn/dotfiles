#! /usr/bin/env fish

## hypr-screenshot.fish ##
## takes screenshots for hyprland requires dunstify for nice notifications

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

    # get window regions
    set workspaces (hyprctl monitors -j | jq -r 'map(.activeWorkspace.id)')
    set windows (hyprctl clients -j | jq -r --argjson workspaces "$workspaces" 'map(select([.workspace.id] | inside($workspaces)))')

    # freeze screen and get region to capture
    hyprpicker -r -z &
    set picker_pid $last_pid
    set region (echo "$windows" | jq -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | slurp)

    # get status to see if selection was cancelled
    set slurp_status $status
    if test $slurp_status -ne 0
        dunstify "$type cancelled" "No problem!"
        exit $slurp_status
    end

    # snap! and get status
    sleep 0.3s
    grim -g $region $name
    set grim_status $status
    kill $picker_pid
else if test "$argv[1]" = "-o"
    set type "Display screenshot"
    set name $folder/$date-o.png

    # freeze screen and get region to capture
    hyprpicker -r -z &
    set picker_pid $last_pid
    set region (slurp -o)

    # get status to see if selection was cancelled
    set slurp_status $status
    if test $slurp_status -ne 0
        dunstify "$type cancelled" "No problem!"
        exit $slurp_status
    end

    # snap! and get status
    sleep 0.3s
    grim -g $region $name
    set grim_status $status
    kill $picker_pid
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
##!/usr/bin/env fish
### Grimblast: a helper for screenshots within hyprland
### Requirements:
###  - `grim`: screenshot utility for wayland
###  - `slurp`: to select an area
###  - `hyprctl`: to read properties of current window
###  - `wl-copy`: clipboard utility
###  - `jq`: json utility to parse hyprctl output
###  - `notify-send`: to show notifications
### Those are needed to be installed, if unsure, run `grimblast check`
###
### See `man 1 grimblast` or `grimblast usage` for further details.

### Author: Misterio (https://github.com/misterio77)

### This tool is based on grimshot, with swaymsg commands replaced by their
### hyprctl equivalents.
### https://github.com/swaywm/sway/blob/master/contrib/grimshot

#function tmp_editor_directory
#  echo "/tmp"
#end

#function env_editor_confirm
#  if test -n "$GRIMBLAST_EDITOR"
#    echo "GRIMBLAST_EDITOR is set. Continuing..."
#  else
#    echo "GRIMBLAST_EDITOR is not set. Defaulting to krita"
#    set GRIMBLAST_EDITOR krita
#  end
#end

#set NOTIFY no
#set CURSOR
#set FREEZE
#set SCALE
#set HYPRPICKER_PID -1

#while test (count $argv) -gt 0
#  switch $argv[1]
#    case '-n' '--notify'
#      set NOTIFY yes
#      set -e argv[1]
#    case '-c' '--cursor'
#      set CURSOR yes
#      set -e argv[1]
#    case '-f' '--freeze'
#      set FREEZE yes
#      set -e argv[1]
#    case '-s' '--scale'
#      set -e argv[1]
#      if test (count $argv) -gt 0
#        set SCALE $argv[1]
#        set -e argv[1]
#      else
#        echo "Error: Missing argument for --scale option."
#        exit 1
#      end
#    case '*'
#      break
#  end
#end

#set ACTION $argv[1]
#set SUBJECT $argv[2]
#set date (date +%Y%m%d-%H%M%S)
#set file $HOME/Pictures/Screenshots/(date -Ins).png
#set file_editor (tmp_editor_directory)/(date -Ins).png

## ... (continue as above, translating other bash constructs to fish)

#killHyprpicker

#function notify
#    notify-send -t 3000 -a grimblast $argv
#end

#function notifyOk
#    notify $argv
#end

#function notify-error
#    set TITLE $argv[2]
#    set TITLE (string join " " $TITLE)
#    set MESSAGE $argv[1]
#    set MESSAGE (string join " " $MESSAGE)
#    notify -u critical "$TITLE" "$MESSAGE"
#end

#function killHyprpicker
#    if [ ! $HYPRPICKER_PID -eq -1 ]; then
#        kill $HYPRPICKER_PID
#    end
#end

#function die
#    killHyprpicker
#    set MSG $argv[1]
#    set MSG (string join " " $MSG)
#    notify-error "Error: $MSG"
#    exit 2
#end

## (Code for handling other subjects)

#if [ "$ACTION" = "copy" ]; then
#    # (Code for copy action)
#else if [ "$ACTION" = "save" ]; then
#    # (Code for save action)
#else if [ "$ACTION" = "edit" ]; then
#    env_editor_confirm
#    if takeScreenshot "$file_editor" "$GEOM" "$OUTPUT"
#        set TITLE "Screenshot of $SUBJECT"
#        set MESSAGE "Open screenshot in image editor"
#        notifyOk "$TITLE" "$MESSAGE" -i "$file_editor"
#        eval $GRIMBLAST_EDITOR "$file_editor"
#        echo "$file_editor"
#    else
#        notify-error "Error taking screenshot"
#    end
#else if [ "$ACTION" = "copysave" ]; then
#    # (Code for copysave action)
#else
#    notify-error "Error taking screenshot with grim"
#end

#killHyprpicker
