{ pkgs, ... }:
{
  home-manager.users.muni.home.packages = with pkgs; [
    ardour
    audacity
    calf
    carla
    geonkick
    infamousPlugins
    lsp-plugins
    musescore
    sfizz
    x42-gmsynth
    x42-plugins
    zynaddsubfx
  ];

  musnix.enable = true;
}
