{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ xwayland-satellite-unstable ];
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };
}
