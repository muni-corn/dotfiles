{
  home.file = {
    ".mrtrust".text = ''
      ~/code/apollo/.mrconfig
      ~/code/liberdus/.mrconfig
    '';
  };

  programs.mr =
    let
      fromMyCodeberg = myRepoName: {
        checkout = "git clone git@codeberg.org:municorn/${myRepoName}.git";
      };
      fromGitHub = myRepoName: {
        checkout = "git clone git@github.com:muni-corn/${myRepoName}.git";
      };
      fromMyGitHubForkRenamed = upstreamOwner: upstreamRepoName: newName: {
        checkout = "git clone git@github.com:muni-corn/${newName}.git";
        post_checkout = "cd $MR_REPO && git remote add upstream git@github.com:${upstreamOwner}/${upstreamRepoName}";
        update = "git fetch --all";
      };
      fromMyGitHubFork =
        upstreamOwner: upstreamRepoName:
        fromMyGitHubForkRenamed upstreamOwner upstreamRepoName upstreamRepoName;

      annex = order: {
        inherit order;
        update = "git annex assist";
        push = "git annex push";
      };
    in
    {
      enable = true;
      settings = {
        DEFAULT.update = "git pull --rebase=true";

        # home-level repos
        dotfiles = fromMyCodeberg "dotfiles";
        notebook = fromMyCodeberg "notebook";

        # annex repos
        Documents = annex 1;
        Music = annex 90; # since this one takes its GOSH DARN TIME
        Pictures = annex 20;
        Videos = annex 15;

        # passwords uwu
        ".local/share/password-store".checkout =
          "git clone https://codeberg.org/municorn/passwords.git password-store";

        # my projects
        "code/muni-wallpapers" = fromGitHub "muni-wallpapers";
        "code/munibot" = fromGitHub "munibot";
        "code/muse-shell" = fromGitHub "muse-shell";
        "code/muse-sounds" = fromMyCodeberg "muse-sounds";
        "code/musicaloft-web".checkout = "git clone git@github.com:musicaloft/musicaloft-web.git";
        "code/nix-templates" = fromGitHub "nix-templates";
        "code/silverfox" = fromGitHub "silverfox";
        "code/unity/muni-vrc" = fromGitHub "muni-vrc";

        # forked repos
        "code/home-manager" = fromMyGitHubFork "nix-community" "home-manager";
        "code/niri-flake" = fromMyGitHubFork "sodiboo" "niri-flake";
        "code/nixpkgs" = fromMyGitHubFork "NixOS" "nixpkgs";
        "code/nixified-ai" = fromMyGitHubForkRenamed "nixified-ai" "flake" "nixified-ai";
        "code/stylix" = fromMyGitHubFork "nix-community" "stylix";

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
