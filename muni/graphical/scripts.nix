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
    "${notebookDir}/journal/${dateDir}.md";

  timew = lib.getExe config.programs.timewarrior.package;
  recordTimew =
    {
      action,
      successTitle,
      failureTitle,
    }:
    writeFishScript "timew-${action}" ''
      set out (eval ${timew} ${action} :yes $argv &| string collect -a)

      if test $pipestatus[1] -eq 0
        notify-send -a "Quick clock" "${successTitle}" "$out"
      else
        notify-send -a "Quick clock" -u critical "${failureTitle}" "$out"
      end
    '';

  promptTimewArgs =
    action: promptText: script:
    pkgs.writeShellScript "prompt-timew-${action}" ''
      args=$(${config.programs.rofi.finalPackage}/bin/rofi -fixed-num-lines 0 -dmenu -p '${promptText}')
      ${script} $args
    '';

  kitty = lib.getExe config.programs.kitty.package;
in
{
  quickCode = import ./quick-code-script.nix { inherit config pkgs; };

  toggleGammastep = ./toggle_gammastep.fish;

  timew =
    let
      start = recordTimew {
        action = "start";
        successTitle = "Clock started";
        failureTitle = "Couldn't start clock";
      };

      stop = recordTimew {
        action = "stop";
        successTitle = "Clock stopped";
        failureTitle = "Couldn't stop clock";
      };
    in
    {
      start = {
        now = start;
        prompt = promptTimewArgs "start" "Started when/what?" start;
      };

      stop = {
        now = stop;
        prompt = promptTimewArgs "stop" "Stopped when/what?" stop;
      };

      status = writeFishScript "timew-status" ''
        notify-send -a "Quick clock" "Time tracking status" "$(${timew} &| string collect -a)"
      '';
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
      wallpapersDir = inputs.muse-wallpapers.generated;
    in
    pkgs.writeShellScript "switch-wallpaper" ''
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
      ${kitty} hx ${filePath}
    '';
}
