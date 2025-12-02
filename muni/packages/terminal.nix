{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # archiving & compression
    gocryptfs
    ouch
    zip

    # file operations
    fd
    jdupes
    sd

    # productivity & time management
    openpomodoro-cli
    peaclock
    pom

    # system utilities
    pv
    tldr

    # utilities & calculators
    fend
    fortune
    qrencode
  ];
}
