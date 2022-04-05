#! /usr/bin/env fish

cat $HOME/.emoji_list.txt | bemenu -p Emoji $argv | string split -m1 -f1 ' ' | wl-copy
