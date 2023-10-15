#!/usr/bin/env fish

# stop services
systemctl --user stop syncthing.service
systemctl --user stop hydroxide.service
systemctl --user stop spotifyd.service
systemctl --user stop swayidle.service
systemctl --user stop kbfs.service
systemctl --user stop keybase.service
