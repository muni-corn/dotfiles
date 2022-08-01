{ bemenuArgsJoined, config, pkgs }:

pkgs.writeScript "quick-code-script"
  ''
    #!${pkgs.fish}/bin/fish

    set dir (${config.programs.zoxide.package}/bin/zoxide query -l | string replace "${config.home.homeDirectory}" "~" | ${pkgs.bemenu}/bin/bemenu -p "Where to?" ${bemenuArgsJoined} || exit 1)

    ${config.programs.zoxide.package}/bin/zoxide add $dir

    ${pkgs.kitty}/bin/kitty -d $dir -e ${pkgs.fish}/bin/fish -i
  ''
