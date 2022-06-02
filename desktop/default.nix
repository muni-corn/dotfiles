# vim: sw=2 ts=2 expandtab
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, flake-inputs, lib, pkgs, ... }:

{
  imports = [
    ../common-configuration.nix

    ./vfio.nix
    ./zfs.nix
    ./hardware.nix
  ];

  boot = {
    loader.grub.gfxmodeEfi = "1920x1080";
    kernelModules = [ "i2c-dev" "i2c-piix4" "kvm-amd" ];
  };

  hardware = {
    opengl.extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
    openrazer = {
      enable = true;
      users = [ "municorn" ];
    };
  };

  musnix = {
    enable = true;
    kernel = {
      optimize = true;
    };
  };

  networking = {
    hostName = "ponycastle";
    hostId = "edafa5da";
  };

  services = {
    # disable fstrim (enabled by nixos-hardware/common-pc-ssd); zfs does it for us
    fstrim.enable = false;

    openssh = {
      enable = true;
      forwardX11 = true;
      startWhenNeeded = true;
      extraConfig = ''
        ClientAliveInterval 30
        ClientAliveCountMax 5
      '';
    };

    pipewire.config.pipewire =
      let
        defaults = lib.importJSON "${flake-inputs.nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json";
      in
      {
        "context.objects" = defaults."context.objects" ++ [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "desktop-audio-proxy";
              "node.description" = "Desktop audio proxy";
              "media.class" = "Audio/Sink";
              "audio.position" = "FL,FR";
            };
          }
        ];
      };

    psd.enable = true;
  };

  systemd.services.openrgb = {
    enable = true;

    description = "OpenRGB server";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.openrgb}/bin/openrgb --server";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  users.users.municorn.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEh29o9VSBHYfXJQFUAXSBmmQsvHc6oDI/ey2VuwdTcN h@munis-MacBook-Pro-13"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDiQnKK6t4m3nb1tHi95gGbLENMS60qLC9KIjVtfwDNzC05BKPRL6Ulg8gqBjyMupZz8e+urs8SGqMpfo303eCXJozyOU4DdsqW7mPOMX+hzWhAlNxLaAq9zTpVN9CISGz0UrgisTX38m25ubHnaTILulXkyIedLvwv4ODhKSaS00G9Mm1DXiTLCwDq/EY/E9pDo3SEYOskDlc0WyyHqxLBrr1yWohPgU7TJtx8cy8muXBcCBsJuyPMsPc+AnxGfwQA9KaJiFTknk2lm3mz+RDoY2d+Mt+y90KZjlq/uXfPiUVgB2dY+3cZcb4J9OzcDGGepKBq3MnqwpkVXs8v3shFb0SSVkUxCfHHqK0KiCsBHhEB5UKVWr64NcD2uQgBHa6EmeLuFIsggYGwEe2CRFvKGAgjMMws5rFAvbe5uzMpcEIOXGLv4qOPOmTZe0xua6eW/DhY8VCjzbbu/Tm2D/8qITmQmY8351UBqnAHGdRUhASDpD0J4wHKKd/+hMm3vFs= municorn@littlepony"
  ];
}


