{
  config,
  pkgs,
  shell,
  ...
}: let
  scriptsDir = builtins.path {
    name = "wm-scripts";
    path = ../wm-scripts;
  };

  # package path convenience variables
  ms = "${pkgs.muse-status}/bin/muse-status";
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  # sound paths
  sounds = {
    volumeDown = "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/volume-down.oga";
    volumeUp = "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/volume-up.oga";
    volumeUnmute = "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/volume-unmute.oga";
  };

  mkVolumeScript = name: pamixerFlags: soundPath:
    pkgs.writeScript "volume-${name}" ''
      #!${shell}
      if set -q VOLUME_CTL_DEFAULT_SINK
        ${pamixer} --sink "$VOLUME_CTL_DEFAULT_SINK" ${pamixerFlags}
        ${pamixer} --sink "$VOLUME_CTL_DEFAULT_SINK" --get-volume > $SWAYSOCK.wob &
      else
        ${pamixer} ${pamixerFlags}
        ${pamixer} --get-volume > $SWAYSOCK.wob &
      end

       ${ms} notify volume &
       ${pkgs.pipewire}/bin/pw-play ${soundPath} &

       wait
    '';
  mkBrightnessScript = name: brilloFlags:
    pkgs.writeShellScript "brightness-${name}" ''
      ${pkgs.brillo}/bin/brillo -q ${brilloFlags}
      ${ms} notify brightness &
      ${pkgs.brillo}/bin/brillo -G | cut -d'.' -f1 > $XDG_RUNTIME_DIR/hypr.wob &
    '';
in {
  dir = scriptsDir;

  screenshot = "${scriptsDir}/screenshot.fish";
  quickCode = import ../quick-code-script.nix {inherit config pkgs;};

  volume = {
    up = mkVolumeScript "up" "-i 5" sounds.volumeUp;
    down = mkVolumeScript "down" "-d 5" sounds.volumeDown;
    toggleMute = mkVolumeScript "toggle-mute" "--toggle-mute" sounds.volumeUnmute;
  };

  brightness = {
    up = mkBrightnessScript "up" "-A 2";
    down = mkBrightnessScript "down" "-U 2";
  };

  switchWallpaper = pkgs.writeScript "hypr-switch-wallpaper" ''
    #!${pkgs.fish}/bin/fish

    set new_wall (${pkgs.fd}/bin/fd --type f . ${config.muse.theme.matchpal.wallpapers.final} | shuf -n 1)
    hyprctl hyprpaper preload $new_wall
    hyprctl hyprpaper wallpaper "HDMI-A-1,$new_wall"
    hyprctl hyprpaper wallpaper "DP-2,$new_wall"
  '';
}
