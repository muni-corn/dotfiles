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
      # home-level repos
      dotfiles.checkout = "git clone https://codeberg.org/municorn/dotfiles";
      notebook.checkout = "git clone https://codeberg.org/municorn/notebook";

      # annex repos
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

      # passwords uwu
      ".local/share/password-store".checkout =
        "git clone https://codeberg.org/municorn/passwords.git password-store";

      # my projects
      "code/muni-wallpapers".checkout = "git clone git@github.com:muni-corn/muni-wallpapers.git";
      "code/muni_bot".checkout = "git clone https://github.com/muni-corn/muni_bot";
      "code/muse-shell".checkout = "git clone https://github.com/muni-corn/muse-shell";
      "code/muse-sounds".checkout = "git clone git@codeberg.org:municorn/muse-sounds";
      "code/musicaloft-web".checkout = "git clone git@github.com:musicaloft/musicaloft-web.git";
      "code/nix-templates".checkout = "git clone git@github.com:muni-corn/nix-templates.git";
      "code/silverfox".checkout = "git clone https://github.com/muni-corn/silverfox";
      "code/unity/muni-vrc".checkout = "git clone git@github.com:muni-corn/muni-vrc";

      # forked repos
      "code/home-manager" = {
        checkout = "git clone git@github.com:muni-corn/home-manager.git";
        post_checkout = "cd home-manager && git remote add upstream git@github.com:nix-community/home-manager";
        update = "git fetch --all";
      };
      "code/nixpkgs" = {
        checkout = "git clone git@github.com:muni-corn/nixpkgs.git";
        post_checkout = "cd nixpkgs && git remote add upstream git@github.com:NixOS/nixpkgs";
        update = "git fetch --all";
      };

      # work repos
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
