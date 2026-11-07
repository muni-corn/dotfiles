{ pkgs, ... }:
# musicaloft-shell already takes care of mostly everything
{
  imports = [
    ./machines
    ./tests
  ];

  packages = with pkgs; [
    # for managing minecraft server modpacks
    packwiz

    # for formatting markdown files in this repo
    oxfmt
  ];
}
