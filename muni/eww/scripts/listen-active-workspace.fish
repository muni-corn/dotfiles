#!/usr/bin/env fish

hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id'

socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - |
  stdbuf -o0 awk -F '>>|,' -e '/^workspace>>/ {print $2}' -e '/^focusedmon>>/ {print $3}'

# `socat` prints information from the hyprland socket `socket2`.
# `stdbuf -o0` tells awk to not buffer its output, so that we can read it in real time

# explanation of the awk script:
# -F '>>|,' sets the field separator to either `>>` or `,`
# /^workspace>>/ {print $2} for lines starting with `workspace>>`, print the second field
# /^focusedmon>>/ {print $3} for lines starting with `focusedmon>>`, print the third field
