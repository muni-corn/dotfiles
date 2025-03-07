{
  imports = [
    ./programs
  ];

  home = {
    extraOutputsToInstall = ["doc" "info" "devdoc"];

    stateVersion = "21.11";

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    username = "muni";
    homeDirectory = "/home/muni";

    sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.npm/bin"
    ];
  };
}
