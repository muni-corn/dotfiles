{
  home.file = {
    ".mrtrust".text = ''
      ~/code/apollo/.mrconfig
      ~/code/liberdus/.mrconfig
    '';
  };

  programs.mr =
    let
      fromMusicaloft = owner: repoName: {
        checkout = "git clone git@git.musicaloft.com:${owner}/${repoName}.git";
      };
      fromMuni = repoName: fromMusicaloft "municorn" repoName;

      fromGitHubForkRenamed = upstreamOwner: upstreamRepoName: newName: {
        checkout = "git clone git@github.com:muni-corn/${newName}.git";
        post_checkout = "cd $MR_REPO && git remote add upstream git@github.com:${upstreamOwner}/${upstreamRepoName} && git remote add musicaloft git@git.musicaloft.com:municorn/${newName}";
        update = "git fetch --all";
      };
      fromGitHubFork =
        upstreamOwner: upstreamRepoName:
        fromGitHubForkRenamed upstreamOwner upstreamRepoName upstreamRepoName;

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
        dotfiles = fromMuni "dotfiles";
        notebook = fromMuni "notebook";

        # annex repos
        Documents = annex 1;
        Music = annex 90; # since this one takes its GOSH DARN TIME
        Pictures = annex 20;
        Videos = annex 15;

        # passwords uwu
        ".local/share/password-store".checkout =
          "git clone git@git.musicaloft.com:municorn/passwords password-store";

        # my projects
        "code/muni-wallpapers" = fromMuni "muni-wallpapers";
        "code/munibot" = fromMuni "munibot";
        "code/muse-shell" = fromMuni "muse-shell";
        "code/muse-sounds" = fromMuni "muse-sounds";
        "code/musicaloft-web" = fromMusicaloft "musicaloft" "musicaloft-web";
        "code/nix-templates" = fromMuni "nix-templates";
        "code/silverfox" = fromMuni "silverfox";
        "code/unity/muni-vrc" = fromMuni "muni-vrc";

        # forked repos
        "code/home-manager" = fromGitHubFork "nix-community" "home-manager";
        "code/niri-flake" = fromGitHubFork "sodiboo" "niri-flake";
        "code/nixpkgs" = fromGitHubFork "NixOS" "nixpkgs";
        "code/nixified-ai" = fromGitHubForkRenamed "nixified-ai" "flake" "nixified-ai";
        "code/stylix" = fromGitHubFork "nix-community" "stylix";
        "code/opencode" = fromGitHubFork "sst" "opencode";
        "code/opencommit" = fromGitHubFork "di-sukharev" "opencommit";

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
