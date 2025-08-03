{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg-full
    imagemagick
    qpdf
    video-trimmer
  ];
}
