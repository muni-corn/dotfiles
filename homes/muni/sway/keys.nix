{ config, lib, sup, alt, bemenuOpts, lockCmd, workspace, ... }:

let
  notebookDir = "$HOME/notebook/";
  shell = "fish";
  terminal = config.wayland.windowManager.sway.config.terminal;

  execWithShell = "${shell} -i -c";

  # apps
  browser = "firefox";
  music = "${terminal} ${execWithShell} spt";
  email = "evolution";
  media = "kodi --windowing=x11";

  # scripts
  scripts_dir = "$HOME/.config/sway/scripts/";
  screenshot = "${scripts_dir}/screenshot.fish";

  # sounds
  volume_down = "$HOME/.nix-profile/share/sounds/musicaflight/stereo/VolumeDown.oga";
  volume_up = "$HOME/.nix-profile/share/sounds/musicaflight/stereo/Volume.oga";
in
{
  # power controls
  "${sup}+Control+${alt}+o" = "exec systemctl poweroff";
  "${sup}+Control+${alt}+r" = "exec systemctl reboot";
  "${sup}+Control+${alt}+s" = "exec systemctl suspend";
  "${sup}+Control+${alt}+b" = "exec systemctl hibernate";

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

  # close window
  "--no-repeat ${sup}+q" = "kill";

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
  "--no-repeat ${sup}+Control+e" = "exec ${scripts_dir}/emoji_menu.fish ${bemenuOpts}";
  "--no-repeat ${sup}+Control+n" = ''exec ${terminal} -d ${notebookDir} ${execWithShell} "nvim ${notebookDir}/new/(date +%Y%m%d-%H%M%S).md"'';
  "--no-repeat ${sup}+Control+p" = "exec pavucontrol";
  "--no-repeat ${sup}+Control+r" = "exec ${scripts_dir}/toggle_gammastep.fish";
  "--no-repeat ${sup}+Return" = "exec ${terminal}";
  "--no-repeat ${sup}+Shift+b" = ''exec ${terminal} -d ${notebookDir} ${execWithShell} "nvim ${notebookDir}/bored.md"'';
  "--no-repeat ${sup}+Shift+m" = "exec ${media}";
  "--no-repeat ${sup}+Shift+n" = ''exec ${terminal} -d ${notebookDir} ${execWithShell} "ranger ${notebookDir}"'';
  "--no-repeat ${sup}+Shift+t" = ''exec ${terminal} -d ${notebookDir} ${execWithShell} "nvim ${notebookDir}/todo.md"'';
  "--no-repeat ${sup}+a" = "exec ${config.wayland.windowManager.sway.config.menu}";
  "--no-repeat ${sup}+c" = "exec ${terminal} ${execWithShell} qalc";
  "--no-repeat ${sup}+b" = "exec ${music}";
  "--no-repeat ${sup}+e" = "exec ${terminal} ${execWithShell} ranger";
  "--no-repeat ${sup}+n" = "exec ${terminal} ${execWithShell} nvim";
  "--no-repeat ${sup}+p" = "exec ${terminal} ${execWithShell} bpytop";
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
  "--no-repeat ${sup}+Control+w" = "exec ${scripts_dir}/random_wallpaper.fish";

  # record clock times (easy clock-in or clock-out :))
  "--no-repeat ${sup}+Delete" = "exec ${notebookDir}/record_time.fish";
  "--no-repeat ${sup}+Home" = "exec ${notebookDir}/record_time.fish '(clock-in)'";
  "--no-repeat ${sup}+End" = "exec ${notebookDir}/record_time.fish '(clock-out)'";
  "--no-repeat ${sup}+Shift+Delete" = "exec ${scripts_dir}/prompt_timestamp.fish ${bemenuOpts}";
  "--no-repeat ${sup}+Shift+Home" = "exec ${scripts_dir}/prompt_clock_in.fish ${bemenuOpts}";
  "--no-repeat ${sup}+Shift+End" = "exec ${scripts_dir}/prompt_clock_out.fish ${bemenuOpts}";

  # exit sway
  "${sup}+Shift+e" = ''exec "pw-play $HOME/.nix-profile/share/sounds/musicaflight/stereo/Goodbye.oga; swaymsg exit"'';

  # volume and brightness controls
  "--locked XF86AudioLowerVolume" = ''exec "pamixer -d 5; muse-status notify volume; pw-play ${volume_down}; pamixer --get-volume > $SWAYSOCK.wob"'';
  "--locked --no-repeat XF86AudioRaiseVolume" = ''exec "pamixer -ui 5; muse-status notify volume; pw-play ${volume_up}; pamixer --get-volume > $SWAYSOCK.wob"'';
  "--locked --no-repeat XF86AudioMute" = ''exec "pamixer --toggle-mute; muse-status notify volume; pw-play ${volume_up}; pamixer --get-volume > $SWAYSOCK.wob"'';
  "XF86MonBrightnessUp" = ''exec "brillo -q -A 2; muse-status notify brightness; brillo -G | cut -d'.' -f1 > $SWAYSOCK.wob"'';
  "XF86MonBrightnessDown" = ''exec "brillo -q -U 2; muse-status notify brightness; brillo -G | cut -d'.' -f1 > $SWAYSOCK.wob"'';

  # player controls
  "--locked --no-repeat XF86AudioPlay" = "exec mpc toggle || playerctl play-pause";
  "--locked --no-repeat XF86AudioNext" = "exec mpc next || playerctl next";
  "--locked --no-repeat XF86AudioPrev" = "exec mpc cdprev || playerctl previous";

  # screen capture
  "--release ${sup}+Print" = "exec ${screenshot}";
  "--release ${sup}+Control+Print" = "exec ${screenshot} -s";
  "--release ${sup}+Control+${alt}+Print" = "exec ${screenshot} -o";
  "--release ${sup}+Shift+Print" = "exec ${scripts_dir}/video_capture.fish";
}
