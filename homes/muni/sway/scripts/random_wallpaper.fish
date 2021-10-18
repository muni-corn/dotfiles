#!/usr/bin/env fish

set existing_swaybg (pidof swaybg)
swaybg -o "*" -m fill -i (fd --type f . ~/Pictures/Wallpapers/Photos/ | shuf -n 1) & disown
sleep 1
kill $existing_swaybg
