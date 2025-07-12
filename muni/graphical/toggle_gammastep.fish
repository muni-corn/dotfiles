#! /usr/bin/env fish

set -l lock_file_path $HOME/.toggle_gammastep.lock

# create a lock file if it doesn't exist already.
# if the lock file exists, it's likely that the script is already running
if ! echo >?$lock_file_path ^/dev/null
    echo "this script is busy"
    exit 1
end

# remove lock on exit
trap "rm -f $lock_file_path" EXIT

set -l feature_name "Night Display"

if systemctl --user --quiet is-active gammastep
    set nid (notify-send -a $feature_name -p -u low "Turning $feature_name off" "Turn $feature_name on before bed to help you sleep better.")
    systemctl --user stop gammastep
    and notify-send -a $feature_name -u low -t 5000 -r $nid "$feature_name is now off" "Turn $feature_name on before bed to help you sleep better."
else
    systemctl --user start gammastep
    and notify-send -a $feature_name -u low -t 5000 "$feature_name is now on" "$feature_name filters blue light to help you sleep when it's late."
end
