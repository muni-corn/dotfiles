#! /usr/bin/env fish

if pgrep -x swaylock > /dev/null
    echo "swaylock is already running"
    exit
end

# parse args
argparse "n/no-fork" "s/startup" "bg-color=" "fg-color=" "primary-color=" "warning-color=" "error-color=" -- $argv; or exit $status

set fork_arg
if set -q $_flag_no_fork
    echo "swaylock won't fork"
    set fork_arg ""
else
    set fork_arg '-f'
end

if ! set -q _flag_startup
    pw-play "/usr/share/sounds/musicaflight/stereo/Lock.oga" &
else
    echo "running in startup mode"
end

set background $_flag_bg_color
set error "{$_flag_error_color}c0"
set foreground "{$_flag_fg_color}c0"
set foreground_faded "{$_flag_fg_color}80"
set primary "{$_flag_primary_color}80"
set transparent "00000000"
set warning "{$_fg_warning_color}"

set image_args ""
set images

# take screenshot of each output and blur it
for output in (swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name')
    set image_file "$HOME/.lock-$output.jpg"
    grim -o $output $image_file
    convert $image_file \
       -resize 5% \
       -fill $background \
       -colorize 25% \
       -blur 10x2 \
       -resize 2000% \
       $image_file
    # TODO: use `composite` to overlay a lock icon
    set image_args $image_args "--image" "$output:$image_file"
    set images $images $image_file
end

swaylock $fork_arg \
    $image_args \
\
    --ignore-empty-password \
    --scaling=fill \
    --disable-caps-lock-text \
    --indicator-caps-lock \
    --color 000000 \
\
    --ring-color=$transparent \
    --ring-wrong-color=$error \
    --ring-ver-color=$transparent \
    --ring-caps-lock-color=$transparent \
    --ring-clear-color=$warning \
\
    --indicator-radius 128 \
    --indicator-thickness 4 \
\
    --inside-color=$transparent \
    --inside-ver-color=$transparent \
    --inside-wrong-color=$transparent \
    --inside-clear-color=$transparent \
    --inside-caps-lock-color=$transparent \
\
    --key-hl-color=$foreground_faded \
    --bs-hl-color=$primary \
    --caps-lock-key-hl-color=$warning \
    --caps-lock-bs-hl-color=$primary \
    --separator-color=$transparent \
    -n \
\
    --text-color=$foreground \
    --text-ver-color=$transparent \
    --text-clear-color=$transparent \
    --text-wrong-color=$transparent \
    --text-caps-lock-color=$warning \
\
    --font "sans Thin" \
    --font-size 12 \

rm $images

if set -q _flag_startup
    pw-play "$HOME/Music/MuseSounds/stereo/Hello.oga"
end
