#!/usr/bin/env fish

function workspaces
    set -l spaces (hyprctl workspaces -j | jq 'map({key: .id | tostring, value: {windows: .windows, monitor: .monitor}}) | from_entries')
    seq 1 10 | jq --argjson spaces "$spaces" --slurp --monochrome-output --compact-output 'map(tostring) | map({id: ., windows: ($spaces[.].windows//0), monitor: ($spaces[.].monitor//"")})'
end

# initialize
workspaces

# for each update from hyprland's socket2, update the workspaces
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read line
    workspaces
end
