{ bemenuArgsJoined, config, pkgs }:

let
  dirs = [
    "~/.config/nixpkgs"
    "~/code/blockery"
    "~/code/chicky-chicky"
    "~/code/matchpal"
    "~/code/muse-status"
    "~/code/silverfox"
    "~/notebook"
  ];

  dirsListFile = pkgs.writeText "quick-code-dir-list" (pkgs.lib.concatStringsSep "\n" dirs);
in
pkgs.writeScript "quick-code-script"
  ''
    #!${pkgs.fish}/bin/fish

    set dir (cat ${dirsListFile} | ${pkgs.bemenu}/bin/bemenu -p "Where to?" ${bemenuArgsJoined} || exit 1)

    ${pkgs.kitty}/bin/kitty -d $dir -e ${pkgs.fish}/bin/fish -i
  ''
