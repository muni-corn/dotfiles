{
  config,
  inputs,
  lib,
  pkgs,
}:
let
  writeFishScript =
    name: script:
    pkgs.writeScript name ''
      #!${config.programs.fish.package}/bin/fish
      ${script}
    '';

  scriptsDir = builtins.path {
    name = "wm-scripts";
    path = ../wm-scripts;
  };

  mkVolumeScript =
    name: wpctlArgs:
    pkgs.writeShellScript "volume-${name}" ''
      wpctl ${wpctlArgs}
      canberra-gtk-play -i audio-volume-change
    '';
  mkBrightnessScript =
    name: brilloFlags:
    pkgs.writeShellScript "brightness-${name}" ''
      ${pkgs.brillo}/bin/brillo -q ${brilloFlags}
    '';

  journalFilePath =
    notebookDir: dateStr:
    let
      split = lib.strings.splitString "/" dateStr;
      parts = map (part: "$(date +${part})") split;
      dateDir = builtins.concatStringsSep "/" parts;
    in
    "${notebookDir}/journal/${dateDir}.norg";

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

    notify-send -a "Quick clock" "Time recorded" "\"$desc\" has been recorded in $display_path."
  '';
in
{
  dir = scriptsDir;

  screenshot = "${scriptsDir}/hypr-screenshot.fish";
  quickCode = import ../quick-code-script.nix { inherit config pkgs; };

  clock =
    let
      mkInstantScript =
        type:
        pkgs.writeShellScript "clock-${type}" ''
          ${recordTime} ${type}
        '';

      mkPromptScript =
        type:
        pkgs.writeShellScript "prompt-clock-${type}" ''
          desc=$(${config.programs.rofi.finalPackage}/bin/rofi -dmenu -p 'Clock ${type} for?')
          ${recordTime} "${type}: $desc"
        '';

      mkClockScriptSet =
        fn:
        (builtins.listToAttrs (
          map (type: lib.nameValuePair type (fn type)) [
            "start"
            "break"
            "stamp"
          ]
        ));
    in
    {
      instant = mkClockScriptSet mkInstantScript;
      prompt = mkClockScriptSet mkPromptScript;
    };

  volume = {
    up = mkVolumeScript "up" "set-volume @DEFAULT_SINK@ 5%+ --limit 1.0";
    down = mkVolumeScript "down" "set-volume @DEFAULT_SINK@ 5%- --limit 1.0";
    toggleMute = mkVolumeScript "toggle-mute" "set-mute @DEFAULT_SINK@ toggle";
  };

  brightness = {
    up = mkBrightnessScript "up" "-A 2";
    down = mkBrightnessScript "down" "-U 2";
  };

  switchWallpaper =
    let
      wallpapersDir = "${inputs.muni-wallpapers}/wallpapers";
    in
    pkgs.writeShellScript "hypr-switch-wallpaper" ''
      new_wall=$(${pkgs.fd}/bin/fd --type f . ${wallpapersDir} | shuf -n 1)
      ${pkgs.swww}/bin/swww img $new_wall
    '';

  openJournalFile =
    notebookDir: dateStr:
    let
      filePath = journalFilePath notebookDir dateStr;
    in
    pkgs.writeShellScript "open-journal-file-${dateStr}" ''
      parent_dir=$(dirname ${filePath})
      mkdir -p $parent_dir
      uwsm-app -T -- $EDITOR ${filePath}
    '';
}
