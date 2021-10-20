#!/usr/bin/env fish

set existing_swaybgs (string split ' ' (pidof swaybg))
swaybg -o "*" -m fill -i (fd --type f . ~/Pictures/Wallpapers/Photos/solarized/ | shuf -n 1) & disown
sleep 1
for pid in $existing_swaybgs
    kill $pid
end
