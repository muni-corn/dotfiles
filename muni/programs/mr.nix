{
  home.file = {
    ".mrtrust".text = ''
      ~/code/apollo/.mrconfig
      ~/code/liberdus/.mrconfig
    '';
  };

  programs.mr = {
    enable = true;
    settings = {
      DEFAULT.jobs = 4;

      dotfiles.checkout = "git clone https://codeberg.org/municorn/dotfiles";
      notebook.checkout = "git clone https://codeberg.org/municorn/notebook";

      Documents = {
        update = "git annex assist";
        push = "git annex push";
        order = 1;
      };

      Music = {
        update = "git annex assist";
        push = "git annex push";
        order = 90; # since this one takes its GOSH DARN TIME
      };

      Pictures = {
        update = "git annex assist";
        push = "git annex push";
        order = 20;
      };

      Videos = {
        update = "git annex assist";
        push = "git annex push";
        order = 15;
      };

      ".local/share/password-store".checkout =
        "git clone https://codeberg.org/municorn/passwords.git password-store";
      "code/muni-wallpapers".checkout = "git clone git@github.com:muni-corn/muni-wallpapers.git";
      "code/muni_bot".checkout = "git clone https://github.com/muni-corn/muni_bot";
      "code/muse-shell".checkout = "git clone https://github.com/muni-corn/muse-shell";
      "code/muse-sounds".checkout = "git clone git@codeberg.org:municorn/muse-sounds";
      "code/musicaloft-web".checkout = "git clone git@github.com:musicaloft/musicaloft-web.git";
      "code/nix-templates".checkout = "git clone git@github.com:muni-corn/nix-templates.git";
      "code/nixpkgs" = {
        checkout = "git clone git@github.com:muni-corn/nixpkgs.git";
        post_checkout = "git remote add upstream git@github.com:NixOS/nixpkgs";
      };
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
