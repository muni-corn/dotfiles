{ config, ... }:
{
  systemd.user.tmpfiles.rules = [
    # create the downloads subvolume with cleanup after 30 days
    "v ${config.xdg.userDirs.download} - - - 30d -"

    # automatically delete trash entires older than 30 days
    "v ${config.xdg.dataHome}/Trash - - - 30d -"

    # create xdg directories as subvolumes;
    # these are also git-annex repositories
    # and subvolumes backed up with btrbk
    "v ${config.xdg.userDirs.documents} - - - - -"
    "v ${config.xdg.userDirs.music} - - - - -"
    "v ${config.xdg.userDirs.pictures} - - - - -"
    "v ${config.xdg.userDirs.videos} - - - - -"

    # create Steam recordings folder as a subvolume so it is not included in btrbk backups
    "v ${config.xdg.userDirs.videos}/Recordings/steam - - - - -"

    # create a subvolume for the code directory
    "v ${config.home.homeDirectory}/code - - - - -"

    # also create a subvolume for the annex
    "v ${config.home.homeDirectory}/annex - - - - -"
  ];
}
