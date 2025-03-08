{ pkgs, ... }:
{
  home-manager.users.muni.home.packages = with pkgs; [
    ardour
    audacity
    calf
    geonkick
    lsp-plugins
    musescore
    sfizz
    x42-gmsynth
    x42-plugins
    zyn-fusion
  ];

  musnix.enable = true;
}
