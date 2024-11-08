{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  writeFishScript = name: script:
    pkgs.writeScript name ''
      #!${config.programs.fish.package}/bin/fish
      ${script}
    '';

  scriptsDir = builtins.path {
    name = "wm-scripts";
    path = ../wm-scripts;
  };

  # package path convenience variables
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  mkVolumeScript = name: pamixerFlags:
    pkgs.writeShellScript "volume-${name}" ''
      ${pamixer} ${pamixerFlags}
      ${pamixer} --get-volume > $XDG_RUNTIME_DIR/hypr.wob &

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
    parts = map (part: "$(date +${part})") split;
    dateDir = builtins.concatStringsSep "/" parts;
  in "${notebookDir}/journal/${dateDir}.norg";

  recordTime = writeFishScript "record-time" ''
    set file $HOME/notebook/times.csv
    set now (date -Iseconds)

    echo "$now,$argv" >>$file

    if ! set -q argv || ! test -n "$argv"
        set desc $now
    else
        set desc "$argv"
    end

    # to simplify the path displayed
    set display_path (string replace ${config.home.homeDirectory} "~" $file)

    ${config.services.dunst.package}/bin/dunstify "Time recorded" "\"$desc\" has been recorded in $display_path."
  '';
in {
  dir = scriptsDir;

  screenshot = "${scriptsDir}/hypr-screenshot.fish";
  quickCode = import ../quick-code-script.nix {inherit config pkgs;};

  clock = let
    mkInstantScript = type:
      pkgs.writeShellScript "clock-${type}" ''
        ${recordTime} ${type}
      '';

    mkPromptScript = type:
      pkgs.writeShellScript "prompt-clock-${type}" ''
        desc=$(${config.programs.rofi.finalPackage}/bin/rofi -dmenu -p 'Clock ${type} for?')
        ${recordTime} "${type}: $desc"
      '';

    mkClockScriptSet = fn: (builtins.listToAttrs (map (type: lib.nameValuePair type (fn type)) ["start" "break" "stamp"]));
  in {
    instant = mkClockScriptSet mkInstantScript;
    prompt = mkClockScriptSet mkPromptScript;
  };

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

  switchWallpaper = let
    wallpapersDir = "${inputs.muni-wallpapers}/wallpapers";
  in
    pkgs.writeShellScript "hypr-switch-wallpaper" ''
      new_wall=$(${pkgs.fd}/bin/fd --type f . ${wallpapersDir} | shuf -n 1)
      ${pkgs.swww}/bin/swww img $new_wall
    '';

  openJournalFile = notebookDir: dateStr: let
    filePath = journalFilePath notebookDir dateStr;
  in
    pkgs.writeShellScript "open-journal-file-${dateStr}" ''
      parent_dir=$(dirname ${filePath})
      mkdir -p $parent_dir
      $EDITOR ${filePath}
    '';
}
