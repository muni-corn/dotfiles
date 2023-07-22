{lib ? import <nixpkgs/lib>, ...}: {
  allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "SpaceCadetPinball"
      "discord"
      "linuxsampler"
      "slack"
      "spotify"
      "spotify-unwrapped"
      "steam"
      "steam-original"
    ];
}
