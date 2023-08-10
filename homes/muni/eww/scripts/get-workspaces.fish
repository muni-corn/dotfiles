#!/usr/bin/env fish


function workspaces
    set -l spaces (hyprctl workspaces -j | jq 'map({key: .id | tostring, value: .windows}) | from_entries')
    seq 1 10 | jq --argjson windows "$spaces" --slurp -Mc 'map(tostring) | map({id: ., windows: ($windows[.]//0)})'
end

# initialize
workspaces

# for each update from hyprland's socket2, update the workspaces
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read line
    workspaces
end
