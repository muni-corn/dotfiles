{lib ? import <nixpkgs/lib>, ...}: {
  allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "SpaceCadetPinball"
      "discord"
      "linuxsampler"
      "mpv-youtube-quality"
      "slack"
      "spotify"
      "spotify-unwrapped"
      "steam"
      "steam-original"
    ];
}
