{ pkgs, ... }:
# musicaloft-shell already takes care of mostly everything
{
  # just add packwiz for managing minecraft server modpacks
  packages = [ pkgs.packwiz ];
}
