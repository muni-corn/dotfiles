{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # archiving & compression
    gocryptfs
    ouch-rar
    zip

    # file operations
    fd
    jdupes
    sd

    # productivity & time management
    openpomodoro-cli
    peaclock
    pom

    # utilities
    fend
    fortune
    internetarchive
    llmfit
    pv
    qrencode
    tldr
  ];
}
