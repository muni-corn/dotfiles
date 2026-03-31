{ pkgs, ... }:
{
  home-manager.users.muni.home.packages = with pkgs; [
    airwindows
    airwindows-lv2
    ardour
    audacity
    calf
    carla
    geonkick
    infamousPlugins
    lsp-plugins
    musescore
    sfizz-ui
    x42-gmsynth
    x42-plugins
    zynaddsubfx

    # reverbs
    aether-lv2
    hybridreverb2
    dragonfly-reverb
    mooSpace
    ir-lv2
    fverb
  ];

  musnix.enable = true;
}
