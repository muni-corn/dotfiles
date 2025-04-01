{
  programs.mr = {
    enable = true;
    settings = {
      dotfiles.checkout = "git clone https://codeberg.org/municorn/dotfiles";

      Documents = {
        update = "git annex assist";
        order = 1;
      };

      Music = {
        update = "git annex assist";
        order = 90; # since this one takes its GOSH DARN TIME
      };

      Pictures = {
        update = "git annex assist";
        order = 20;
      };

      Videos = {
        update = "git annex assist";
        order = 15;
      };

      ".local/share/password-store".checkout =
        "git clone https://codeberg.org/municorn/passwords.git password-store";
      "code/muni-wallpapers".checkout = "git clone git@github.com:muni-corn/muni-wallpapers.git";
      "code/muni_bot".checkout = "git clone https://github.com/muni-corn/muni_bot";
      "code/muse-shell".checkout = "git clone https://github.com/muni-corn/muse-shell";
      "code/muse-sounds".checkout = "git clone git@codeberg.org:municorn/muse-sounds";
      "code/musicaloft-web".checkout = "git clone git@github.com:musicaloft/musicaloft-web.git";
      "code/silverfox".checkout = "git clone https://github.com/muni-corn/silverfox";
      "code/unity/muni-vrc".checkout = "git clone git@github.com:muni-corn/muni-vrc";

      "code/apollo" = {
        skip = true;
        chain = true;
      };

      "code/liberdus" = {
        skip = true;
        chain = true;
      };
    };
  };
}
