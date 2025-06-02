{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ xwayland-satellite-unstable ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  systemd.user.services.niri-flake-polkit.enable = false;
}
