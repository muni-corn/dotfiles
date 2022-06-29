{ config, lib, pkgs, sup, alt, bemenuArgsJoined, lockCmd, workspace, scriptsDir, wallpaperSwitchScript, ... }:

let
  notebookDir = "${config.home.homeDirectory}/notebook/";
  shell = "fish";
  terminal = config.wayland.windowManager.sway.config.terminal;
  terminalInDir = dir: "${terminal} -d ${dir}";

  withShell = cmd: ''${shell} -i -c "${cmd}"'';

  # apps
  browser = "firefox";
  music = ''${terminal} ${withShell "spt"}'';
  email = "evolution";
  media = "kodi --windowing=x11";

  # sounds
  volumeDownSound = "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/VolumeDown.oga";
  volumeUpSound = "${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/Volume.oga";

  # package path convenience variables
  ms = "${pkgs.muse-status}/bin/muse-status";
  pamixer = "${pkgs.pamixer}/bin/pamixer";

  # scripts
  screenshot = "${scriptsDir}/screenshot.fish";

  # volume scripts
  volumeScript = name: pamixerFlags: soundPath: pkgs.writeScript "volume-${name}" ''
    #!${pkgs.fish}/bin/fish
    if set -q VOLUME_CTL_DEFAULT_SINK
      ${pamixer} --sink "$VOLUME_CTL_DEFAULT_SINK" ${pamixerFlags}
      ${pamixer} --sink "$VOLUME_CTL_DEFAULT_SINK" --get-volume > $SWAYSOCK.wob &
    else
      ${pamixer} ${pamixerFlags}
      ${pamixer} --get-volume > $SWAYSOCK.wob &
    end

     ${ms} notify volume &
     pw-play ${soundPath} &

     wait
  '';
  volumeUp = volumeScript "up" "-i 5" volumeUpSound;
  volumeDown = volumeScript "down" "-d 5" volumeDownSound;
  toggleMute = volumeScript "toggle-mute" "--toggle-mute" volumeUpSound;

  # brightness scripts
  brightnessScript = name: brilloFlags: pkgs.writeShellScript "brightness-${name}" ''
    brillo -q ${brilloFlags}
    ${ms} notify brightness &
    brillo -G | cut -d'.' -f1 > $SWAYSOCK.wob &
  '';
  brightnessUp = brightnessScript "up" "-A 2";
  brightnessDown = brightnessScript "down" "-U 2";
in
{
  # power controls
  "${sup}+Control+${alt}+o" = "exec systemctl poweroff";
  "${sup}+Control+${alt}+b" = "exec systemctl reboot";
  "${sup}+Control+${alt}+s" = "exec systemctl suspend";

  # change focus
  "${sup}+h" = "focus left";
  "${sup}+j" = "focus down";
  "${sup}+k" = "focus up";
  "${sup}+l" = "focus right";
  "${sup}+Left" = "focus left";
  "${sup}+Down" = "focus down";
  "${sup}+Up" = "focus up";
  "${sup}+Right" = "focus right";
  "${sup}+Tab" = "focus next";
  "${sup}+Shift+Tab" = "focus prev";

  # move focused window
  "${sup}+Shift+h" = "move left";
  "${sup}+Shift+j" = "move down";
  "${sup}+Shift+k" = "move up";
  "${sup}+Shift+l" = "move right";
  "${sup}+Shift+Left" = "move left";
  "${sup}+Shift+Down" = "move down";
  "${sup}+Shift+Up" = "move up";
  "${sup}+Shift+Right" = "move right";

  # move focused workspace to outputs
  "${sup}+Control+h" = "move workspace to left";
  "${sup}+Control+j" = "move workspace to down";
  "${sup}+Control+k" = "move workspace to up";
  "${sup}+Control+l" = "move workspace to right";
  "${sup}+Control+Left" = "move workspace to left";
  "${sup}+Control+Down" = "move workspace to down";
  "${sup}+Control+Up" = "move workspace to up";
  "${sup}+Control+Right" = "move workspace to right";

  # quick resize
  "${sup}+${alt}+h" = "resize shrink width 20 px";
  "${sup}+${alt}+j" = "resize grow height 20 px";
  "${sup}+${alt}+k" = "resize shrink height 20 px";
  "${sup}+${alt}+l" = "resize grow width 20 px";
  "${sup}+${alt}+Left" = "resize shrink width 20 px";
  "${sup}+${alt}+Down" = "resize grow height 20 px";
  "${sup}+${alt}+Up" = "resize shrink height 20 px";
  "${sup}+${alt}+Right" = "resize grow width 20 px";

  # other window controls
  "--no-repeat ${sup}+q" = "kill";
  "--no-repeat ${sup}+x" = "sticky toggle";

  # switch between floating/tiled layers
  "--no-repeat ${sup}+z" = "focus mode_toggle";
  "--no-repeat ${sup}+Shift+z" = "focus parent";
  "--no-repeat ${sup}+Control+z" = "focus child";

  # change container layout
  "--no-repeat ${sup}+t" = "layout tabbed";
  "--no-repeat ${sup}+y" = "layout toggle split";
  "--no-repeat ${sup}+u" = "layout stacking";
  "--no-repeat ${sup}+o" = "split toggle";
  "--no-repeat ${sup}+f" = "fullscreen toggle";

  # shortcuts for apps
  "--no-repeat ${sup}+Control+e" = "exec ${scriptsDir}/emoji_menu.fish ${bemenuArgsJoined}";
  "--no-repeat ${sup}+Control+n" = ''exec ${terminalInDir notebookDir} ${withShell "nvim ${notebookDir}/new/(date +%Y%m%d-%H%M%S).norg"}'';
  "--no-repeat ${sup}+Control+p" = "exec pavucontrol";
  "--no-repeat ${sup}+Control+r" = "exec ${scriptsDir}/toggle_gammastep.fish";
  "--no-repeat ${sup}+Control+t" = ''exec ${terminalInDir notebookDir} ${withShell "nvim ${notebookDir}/todo.norg"}'';
  "--no-repeat ${sup}+Return" = "exec ${terminal}";
  "--no-repeat ${sup}+Shift+b" = ''exec ${terminalInDir notebookDir} ${withShell "nvim ${notebookDir}/bored.norg"}'';
  "--no-repeat ${sup}+Shift+m" = "exec ${media}";
  "--no-repeat ${sup}+Shift+n" = ''exec ${terminalInDir notebookDir} ${withShell "nnn ${notebookDir}"}'';
  "--no-repeat ${sup}+a" = "exec ${config.wayland.windowManager.sway.config.menu}";
  "--no-repeat ${sup}+c" = ''exec ${terminal} ${withShell "qalc"}'';
  "--no-repeat ${sup}+b" = "exec ${music}";
  "--no-repeat ${sup}+e" = ''exec ${terminal} ${withShell "nnn"}'';
  "--no-repeat ${sup}+n" = ''exec ${terminal} ${withShell "nvim"}'';
  "--no-repeat ${sup}+p" = ''exec ${terminal} ${withShell "htop"}'';
  "--no-repeat ${sup}+w" = "exec ${browser}";

  # lock
  "--no-repeat ${sup}+Escape" = "exec ${lockCmd}";

  # notifications
  "--no-repeat Control+Escape" = "exec dunstctl close";
  "--no-repeat ${sup}+Minus" = "exec dunstctl close";
  "--no-repeat ${sup}+Equal" = "exec dunstctl history-pop";
  "--no-repeat ${sup}+Space" = "exec dunstctl context";

  # toggle floating. also set border in case we're coming from floating video mode
  "--no-repeat ${sup}+s" = "floating toggle; border normal 6";

  # floating video mode
  "--no-repeat ${sup}+i" = "fullscreen disable,\\
  floating enable,\\
  sticky enable,\\
  border pixel 6,\\
  resize set 356 200,\\
  move position 1564 px 0 px,\\
  inhibit_idle open";
  "--no-repeat ${sup}+Shift+i" = "fullscreen disable,\\
  floating enable,\\
  sticky enable,\\
  border pixel 6,\\
  resize set 711 400,\\
  move position 1209 px 0 px,\\
  inhibit_idle open";

  # mobile (as in cell phone) width
  "${sup}+m" = "resize set width 512 px";

  # switch to workspace
  "${sup}+1" = "workspace ${workspace 0}";
  "${sup}+2" = "workspace ${workspace 1}";
  "${sup}+3" = "workspace ${workspace 2}";
  "${sup}+4" = "workspace ${workspace 3}";
  "${sup}+5" = "workspace ${workspace 4}";
  "${sup}+6" = "workspace ${workspace 5}";
  "${sup}+7" = "workspace ${workspace 6}";
  "${sup}+8" = "workspace ${workspace 7}";
  "${sup}+9" = "workspace ${workspace 8}";
  "${sup}+0" = "workspace ${workspace 9}";

  # move focused container to workspace
  "${sup}+Shift+1" = "move container to workspace ${workspace 0}";
  "${sup}+Shift+2" = "move container to workspace ${workspace 1}";
  "${sup}+Shift+3" = "move container to workspace ${workspace 2}";
  "${sup}+Shift+4" = "move container to workspace ${workspace 3}";
  "${sup}+Shift+5" = "move container to workspace ${workspace 4}";
  "${sup}+Shift+6" = "move container to workspace ${workspace 5}";
  "${sup}+Shift+7" = "move container to workspace ${workspace 6}";
  "${sup}+Shift+8" = "move container to workspace ${workspace 7}";
  "${sup}+Shift+9" = "move container to workspace ${workspace 8}";
  "${sup}+Shift+0" = "move container to workspace ${workspace 9}";

  # scratchpad (minimize)
  "--no-repeat ${sup}+v" = "move scratchpad";
  "--no-repeat ${sup}+Shift+v" = "scratchpad show";

  # reload
  "--no-repeat ${sup}+Shift+r" = "reload";

  # change wallpaper
  "--no-repeat ${sup}+Control+w" = lib.mkIf config.muse.theme.matchpal.enable "exec ${wallpaperSwitchScript}";

  # record clock times (easy clock-in or clock-out :))
  "--no-repeat ${sup}+Delete" = "exec ${notebookDir}/record_time.fish";
  "--no-repeat ${sup}+Home" = "exec ${notebookDir}/record_time.fish '(clock-in)'";
  "--no-repeat ${sup}+End" = "exec ${notebookDir}/record_time.fish '(clock-out)'";
  "--no-repeat ${sup}+Shift+Delete" = "exec ${scriptsDir}/prompt_timestamp.fish ${bemenuArgsJoined}";
  "--no-repeat ${sup}+Shift+Home" = "exec ${scriptsDir}/prompt_clock_in.fish ${bemenuArgsJoined}";
  "--no-repeat ${sup}+Shift+End" = "exec ${scriptsDir}/prompt_clock_out.fish ${bemenuArgsJoined}";

  # exit sway
  "${sup}+Shift+e" = ''exec "pw-play ${pkgs.muse-sounds}/share/sounds/musicaloft/stereo/Goodbye.oga; swaymsg exit"'';

  # volume and brightness controls
  "--locked XF86AudioLowerVolume" = "exec ${volumeDown}";
  "--locked --no-repeat XF86AudioRaiseVolume" = "exec ${volumeUp}";
  "--locked --no-repeat XF86AudioMute" = "exec ${toggleMute}";
  "XF86MonBrightnessUp" = "exec ${brightnessUp}";
  "XF86MonBrightnessDown" = "exec ${brightnessDown}";

  # player controls
  "--locked --no-repeat XF86AudioPlay" = "exec mpc toggle || playerctl play-pause";
  "--locked --no-repeat XF86AudioNext" = "exec mpc next || playerctl next";
  "--locked --no-repeat XF86AudioPrev" = "exec mpc cdprev || playerctl previous";

  # screen capture
  "--release ${sup}+Print" = "exec ${screenshot}";
  "--release ${sup}+Control+Print" = "exec ${screenshot} -s";
  "--release ${sup}+Control+${alt}+Print" = "exec ${screenshot} -o";
  "--release ${sup}+Shift+Print" = "exec ${scriptsDir}/video_capture.fish";
}
