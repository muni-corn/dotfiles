#!/usr/bin/env fish
hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | stdbuf -o0 awk -F '>>|,' '/^focusedmon>>/{print $2}'
