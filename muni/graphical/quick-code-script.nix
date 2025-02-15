/*
Simplifies and quickens the process of opening a terminal and using `z` (zoxide)
to navigate to a directory, a *super* common first couple of steps when doing
anything in the terminal. This speeds it up by using `rofi` to pick from a
list of directories in the zoxide database. (And directories unknown to zoxide
should be allowed too; they will be added to zoxide if so)
*/
{
  config,
  pkgs,
}: let
  z = "${config.programs.zoxide.package}/bin/zoxide";
  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";
  fish = "${config.programs.fish.package}/bin/fish";
in
  pkgs.writeScript "quick-code-script"
  ''
    #!${fish}

    set dir (${z} query -l | string replace "${config.home.homeDirectory}" "~" | ${rofi} -dmenu -p "Where to?" || exit 1)

    ${z} add $dir

    # can't use -1 flag here; kitty cannot open in the specified directory if used
    ${pkgs.kitty}/bin/kitty -d $dir -e ${fish} -i
  ''
