{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    mkMerge
    ;

  soundsCfg = config.xdg.sounds;
  themeCfg = soundsCfg.theme;
  canberraCfg = soundsCfg.canberra-boot;

  themeDir = "${themeCfg.package}/share/sounds/${themeCfg.name}";

  # derivation that symlinks custom theme boot/shutdown sounds into the
  # freedesktop directory structure. canberra-boot hardcodes the
  # "freedesktop" theme, so we place the custom theme's sounds where
  # canberra-boot expects to find them.
  canberraBootSounds = pkgs.runCommand "canberra-boot-sounds" { } ''
    mkdir -p $out/share/sounds/freedesktop/stereo

    link_sound() {
      local event="$1"
      shift

      for candidate in "$@"; do
        for ext in oga ogg wav; do
          src="${themeDir}/stereo/$candidate.$ext"
          if [ -f "$src" ]; then
            ln -s "$src" "$out/share/sounds/freedesktop/stereo/$event.$ext"
            return
          fi
        done
      done
    }

    # system-bootup: prefer system-bootup, fall back to system-ready
    link_sound system-bootup system-bootup system-ready

    # system-shutdown: direct match
    link_sound system-shutdown system-shutdown

    # system-shutdown-reboot: prefer specific, fall back to system-shutdown
    link_sound system-shutdown-reboot system-shutdown-reboot system-shutdown
  '';

  canberraBootBin = lib.getExe' canberraCfg.package "canberra-boot";

  # common service config shared by all three canberra-boot services
  commonServiceConfig = {
    Type = "oneshot";
    Environment = "XDG_DATA_DIRS=/run/current-system/sw/share";
  };
in
{
  meta.maintainers = with lib.maintainers; [ municorn ];

  options.xdg.sounds = {
    theme = {
      name = mkOption {
        type = types.str;
        default = "freedesktop";
        description = ''
          Name of the XDG sound theme to use system-wide.
        '';
      };

      package = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = ''
          Package providing the sound theme files. When set, this
          package is added to system packages and `xdg.sounds.enable`
          is forced on.
        '';
      };
    };

    canberra-boot = {
      enable = mkEnableOption "playing sounds on system boot and shutdown using canberra-boot";

      package = mkPackageOption pkgs "libcanberra" { };
    };
  };

  config = mkMerge [
    (mkIf (themeCfg.package != null) {
      xdg.sounds.enable = true;
      environment.systemPackages = [ themeCfg.package ];
    })

    (mkIf canberraCfg.enable {
      assertions = [
        {
          assertion = themeCfg.package != null;
          message = "xdg.sounds.theme.package must be set when canberra-boot is enabled";
        }
      ];

      environment.systemPackages = [
        canberraCfg.package
        (lib.setPrio 1 canberraBootSounds)
      ];

      systemd.services = {
        canberra-system-bootup = {
          description = "Play Bootup Sound";
          # sound.target is passive and not pulled into the boot sequence by default,
          # so we use multi-user.target to ensure this actually runs on boot.
          wantedBy = [ "multi-user.target" ];
          after = [ "alsa-restore.service" ];
          before = [ "shutdown.target" ];
          conflicts = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = commonServiceConfig // {
            ExecStart = "${canberraBootBin} system-bootup";
          };
        };

        canberra-system-shutdown = {
          description = "Play Shutdown Sound";
          wantedBy = [
            "halt.target"
            "poweroff.target"
          ];
          before = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = commonServiceConfig // {
            ExecStart = "${canberraBootBin} system-shutdown";
          };
        };

        canberra-system-shutdown-reboot = {
          description = "Play Reboot Sound";
          wantedBy = [
            "reboot.target"
            "kexec.target"
          ];
          before = [ "shutdown.target" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = commonServiceConfig // {
            ExecStart = "${canberraBootBin} system-shutdown-reboot";
          };
        };
      };
    })
  ];
}
