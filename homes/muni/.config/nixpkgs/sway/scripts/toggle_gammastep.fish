#! /usr/bin/env fish

if pgrep -x gammastep > /dev/null
    systemctl --user stop gammastep
    and notify-send -u low -t 5000 "Night Display is now off" "Turn Night Display on before bed to help you sleep better."
else
    systemctl --user start gammastep
    and notify-send -u low -t 5000 "Night Display is now on" "Night Display filters blue light to help you sleep when it's late."
end
