{
  config,
  lib,
  pkgs,
  ...
}: let
  scriptsDir = builtins.path {
    name = "wm-scripts";
    path = ../wm-scripts;
  };

  # package path convenience variables
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  mkVolumeScript = name: pamixerFlags:
    pkgs.writeScript "volume-${name}" ''
      #!${config.programs.fish.package}/bin/fish
      if set -q VOLUME_CTL_DEFAULT_SINK
        ${pamixer} --sink "$VOLUME_CTL_DEFAULT_SINK" ${pamixerFlags}
        ${pamixer} --sink "$VOLUME_CTL_DEFAULT_SINK" --get-volume > $XDG_RUNTIME_DIR/hypr.wob &
      else
        ${pamixer} ${pamixerFlags}
        ${pamixer} --get-volume > $XDG_RUNTIME_DIR/hypr.wob &
      end

      canberra-gtk-play -i audio-volume-change &

      wait
    '';
  mkBrightnessScript = name: brilloFlags:
    pkgs.writeShellScript "brightness-${name}" ''
      ${pkgs.brillo}/bin/brillo -q ${brilloFlags}
      ${pkgs.brillo}/bin/brillo -G | cut -d'.' -f1 > $XDG_RUNTIME_DIR/hypr.wob &
    '';

  journalFilePath = notebookDir: dateStr: let
    split = lib.strings.splitString "/" dateStr;
    parts = map (part: "(date +${part})") split;
    dateDir = builtins.concatStringsSep "/" parts;
  in "${notebookDir}/journal/${dateDir}.norg";
in {
  dir = scriptsDir;

  screenshot = "${scriptsDir}/hypr-screenshot.fish";
  quickCode = import ../quick-code-script.nix {inherit config pkgs;};

  volume = {
    up = mkVolumeScript "up" "-i 5";
    down = mkVolumeScript "down" "-d 5";
    toggleMute = mkVolumeScript "toggle-mute" "--toggle-mute";
  };

  brightness = {
    up = mkBrightnessScript "up" "-A 2";
    down = mkBrightnessScript "down" "-U 2";
  };

  startWob = pkgs.writeShellScript "wob-start" ''
    mkfifo $XDG_RUNTIME_DIR/hypr.wob
    tail -f $XDG_RUNTIME_DIR/hypr.wob | ${pkgs.wob}/bin/wob
  '';

  switchWallpaper = pkgs.writeShellScript "hypr-switch-wallpaper" ''
    new_wall=$(${pkgs.fd}/bin/fd --type f . ${config.muse.theme.wallpapersDir} | shuf -n 1)
    ${pkgs.swww}/bin/swww img $new_wall
  '';

  openJournalFile = notebookDir: dateStr: let
    filePath = journalFilePath notebookDir dateStr;
  in
    pkgs.writeScript "open-journal-file-${dateStr}" ''
      #!${pkgs.fish}/bin/fish
      set parent_dir (path dirname ${filePath})
      mkdir -p $parent_dir
      $EDITOR ${filePath}
    '';
}
