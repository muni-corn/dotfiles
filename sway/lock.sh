#!/usr/bin/env bash

if pgrep -x swaylock >/dev/null
then
    echo "swaylock is already running"
else
    paplay "$HOME/Drive/Music/MuseSounds/Lock.ogg" &
fi

FORK='-f'

if [ $# -gt 0 ]; then
    if [ $1 = "--no-fork" ]; then
        echo "swaylock won't fork"
        FORK=''
    fi
fi

tmpbg='/tmp/screen.png'

cp $HOME/.config/wpg/wallpapers/$(wpg -c) $tmpbg
/usr/bin/convert "$tmpbg" \
    -resize 1920x1080^ \
    -gravity center \
    -extent 1920x1080 \
    -fill "#0f1317" \
    -colorize 75% \
    "$tmpbg"

primary="eaffffff"
secondary="7ca9cbe5"

swaylock $FORK -t -i "$tmpbg" \
    -e \
    --ring-color=00000000 \
    --ring-wrong-color=ff0000aa \
    --ring-ver-color=$secondary \
\
    --indicator-radius 32 \
    --indicator-thickness 4 \
\
    --inside-color=00000000 \
    --inside-ver-color=00000000 \
    --inside-wrong-color=00000000 \
\
    --key-hl-color=$primary \
    --bs-hl-color=$secondary \
    --separator-color=00000000 \
    --line-color=00000000 \
\
    --text-color=$primary \
    --text-ver-color=$secondary \
    --text-wrong-color=ff0000aa \
\
    --font="Roboto 10" \
