/*
  Simplifies and quickens the process of opening a terminal and using `z` (zoxide)
  to navigate to a directory, a *super* common first couple of steps when doing
  anythign in the terminal. This speeds it up by using `bemenu` to pick from a
  list of directories in the zoxide database. (And directories unknown to zoxide
  should be allowed too; they will be added to zoxide if so)
*/
{ bemenuArgsJoined, config, pkgs }:

pkgs.writeScript "quick-code-script"
  ''
    #!${pkgs.fish}/bin/fish

    set dir (${config.programs.zoxide.package}/bin/zoxide query -l | string replace "${config.home.homeDirectory}" "~" | ${pkgs.bemenu}/bin/bemenu -p "Where to?" ${bemenuArgsJoined} || exit 1)

    ${config.programs.zoxide.package}/bin/zoxide add $dir

    ${pkgs.kitty}/bin/kitty -d $dir -e ${pkgs.fish}/bin/fish -i
  ''
