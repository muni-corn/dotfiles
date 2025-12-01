{ pkgs, ... }:
{
  home.file = {
    ".mrtrust".text = ''
      ~/code/orosa/.mrconfig
      ~/code/liberdus/.mrconfig
    '';
  };

  programs.mr =
    let
      # fixups
      fixupMuniRepo =
        repoName:
        pkgs.writeShellScript "mr-fixup-${repoName}" ''
          cd $MR_REPO
          git remote get-url github > /dev/null || git remote add -f github git@github.com:muni-corn/${repoName}
          git remote get-url codeberg > /dev/null || git remote add -f codeberg git@codeberg.org:municorn/${repoName}
        '';
      fixupGitHubFork =
        upstreamOwner: upstreamRepoName: newName:
        pkgs.writeShellScript "mr-fixup-gh-${newName}" ''
          cd $MR_REPO
          git remote get-url upstream > /dev/null || git remote add -f upstream git@github.com:${upstreamOwner}/${upstreamRepoName}
          git remote get-url codeberg > /dev/null || git remote add -f upstream git@codeberg.org:municorn/${newName}
          git remote get-url musicaloft > /dev/null || git remote add -f musicaloft git@git.musicaloft.com:municorn/${newName}
        '';

      # easy repo creation utils
      fromMusicaloft = owner: repoName: {
        checkout = "git clone git@git.musicaloft.com:${owner}/${repoName}.git";
      };
      fromMuni =
        repoName:
        (fromMusicaloft "municorn" repoName)
        // {
          fixups = builtins.toString (fixupMuniRepo repoName);
        };

      # github utils
      fromGitHubForkRenamed = upstreamOwner: upstreamRepoName: newName: {
        checkout = "git clone git@github.com:muni-corn/${newName}.git";
        fixups = builtins.toString (fixupGitHubFork upstreamOwner upstreamRepoName newName);
        update = "git fetch --all";
      };
      fromGitHubFork =
        upstreamOwner: upstreamRepoName:
        fromGitHubForkRenamed upstreamOwner upstreamRepoName upstreamRepoName;

      # util for annex repos
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
        "code/cocoa" = fromMuni "cocoa";
        "code/muni-wallpapers" = fromMuni "muni-wallpapers";
        "code/munibot" = fromMuni "munibot";
        "code/cadenza-shell" = fromMuni "cadenza-shell";
        "code/cadenza-sounds" = fromMuni "cadenza-sounds";
        "code/musicaloft-web" = fromMusicaloft "musicaloft" "musicaloft-web";
        "code/nix-templates" = fromMuni "nix-templates";
        "code/silverfox" = fromMuni "silverfox";
        "code/unity/muni-vrc" = fromMuni "muni-vrc";

        # forked repos
        "code/commitlint-rs" = fromGitHubFork "KeisukeYamashita" "commitlint-rs";
        "code/devenv" = fromGitHubFork "cachix" "devenv";
        "code/home-manager" = fromGitHubFork "nix-community" "home-manager";
        "code/niri-flake" = fromGitHubFork "sodiboo" "niri-flake";
        "code/nixpkgs" = fromGitHubFork "NixOS" "nixpkgs";
        "code/nixified-ai" = fromGitHubForkRenamed "nixified-ai" "flake" "nixified-ai";
        "code/relm4" = fromGitHubFork "Relm4" "relm4";
        "code/relm4-icons" = fromGitHubForkRenamed "Relm4" "icons" "relm4-icons";
        "code/stylix" = fromGitHubFork "nix-community" "stylix";
        "code/opencode" = fromGitHubFork "sst" "opencode";
        "code/opencommit" = fromGitHubFork "di-sukharev" "opencommit";

        # work repos
        "code/orosa" = {
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
