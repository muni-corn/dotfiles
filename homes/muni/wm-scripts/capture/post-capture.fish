#!/usr/bin/env fish

# start services that were stopped before
systemctl --user start syncthing.service
systemctl --user start hydroxide.service
systemctl --user start spotifyd.service
systemctl --user start swayidle.service
systemctl --user start kbfs.service
systemctl --user start keybase.service
