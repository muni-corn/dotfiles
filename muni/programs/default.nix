{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./helix.nix
    ./nnn.nix
    ./nvim
    ./starship.nix
  ];

  programs = {
    # let home-manager install and manage itself
    home-manager.enable = true;

    bat.enable = true;

    btop.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      git = true;
      icons = "auto";
    };

    gpg.enable = true;

    jq.enable = true;

    # fish integration enabled by default
    nix-index.enable = true;

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-otp
        exts.pass-update
      ]);
      settings = {
        PASSWORD_STORE_DIR = "$HOME/.password-store";
        PASSWORD_STORE_KEY = "4B21310A52B15162";
      };
    };

    ranger = {
      enable = true;
      settings = {
        preview_images = true;
        preview_images_method = "kitty";
      };
    };

    ripgrep.enable = true;

    skim = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = ''fd --type f'';
    };

    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      config = {
        sync = {
          encryption_secret = "@terr1b!3encrypt!on$ecr3t";
          server = {
            url = "http://192.168.68.70:10222";
            client_id = "89440068-6754-49d6-adaf-007f78f06070";
          };
        };

        # remove news popup
        verbose = "affected,blank,context,edit,header,footnote,label,new-id,project,special,sync,override,recur";
      };
    };

    yazi = {
      enable = true;
      shellWrapperName = "y";

      initLua = ''
        Status:children_add(function(self)
        	local h = self._current.hovered
        	if h and h.link_to then
        		return " -> " .. tostring(h.link_to)
        	else
        		return ""
        	end
        end, 3300, Status.LEFT)

        Status:children_add(function()
        	local h = cx.active.current.hovered
        	if h == nil or ya.target_family() ~= "unix" then
        		return ""
        	end

        	return ui.Line {
        		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
        		":",
        		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
        		" ",
        	}
        end, 500, Status.RIGHT)
      '';

      keymap = {
        manager.prepend_keymap = [
          {
            on = "!";
            run = ''shell "$SHELL" --block'';
            desc = "Open shell here";
          }
          {
            on = "<C-n>";
            run = ''shell -- dragon -x -i -T "$1"'';
            desc = "Open dragon dialog";
          }
        ];
      };
      settings = {
        manager = {
          show_hidden = true;
          sort_by = "natural";
          sort_translit = true;
          linemode = "size";
        };
        preview = {
          max_width = 2000;
          max_height = 1000;
          image_filter = "lanczos3";
          image_quality = 85;
        };
      };
    };

    yt-dlp.enable = true;

    zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        default_mode = "locked";
      };
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
