{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
    qpdf
    ueberzugpp
    video-trimmer
  ];
}
