{ lib, pkgs, ... }:
{
  programs.yazi = {
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
      mgr.prepend_keymap =
        let
          # TODO: dedupe with gtk bookmarks
          bookmarks = {
            D = "~/dotfiles";
            M = "~/Documents";
            a = "~/Music/ardour";
            c = "~/code";
            d = "~/Documents";
            m = "~/Music";
            n = "~/notebook";
            o = "~/Downloads";
            p = "~/Pictures";
            s = "~/Pictures/Screenshots";
            v = "~/Videos";
            y = "~/sync";
          };

          bookmarkMaps = lib.attrsets.mapAttrsToList (key: dir: {
            on = [
              "g"
              key
            ];
            run = "cd '${dir}'";
            desc = "Go to ${dir}";
          }) bookmarks;
        in
        bookmarkMaps
        ++ [
          {
            on = "!";
            run = ''shell "$SHELL" --block'';
            desc = "Open shell here";
          }
          {
            on = "<C-n>";
            run = ''shell -- ${pkgs.dragon-drop}/bin/dragon-drop -x -T "$1"'';
            desc = "Open dragon dialog";
          }
          {
            on = "C";
            run = "plugin ouch";
            desc = "Compress with ouch";
          }
        ];
    };

    plugins = {
      inherit (pkgs.yaziPlugins)
        bypass
        chmod
        git
        mediainfo
        mount
        ouch
        restore
        rich-preview
        rsync
        smart-enter
        sudo
        time-travel
        ;
    };

    settings = {
      mgr = {
        show_hidden = true;
        sort_by = "natural";
        sort_translit = true;
        linemode = "size";
      };
      opener.extract = [
        {
          run = ''ouch d -y "$@"'';
          desc = "Extract here with ouch";
          for = "unix";
        }
      ];
      preview = {
        max_width = 2000;
        max_height = 1000;
        image_filter = "lanczos3";
        image_quality = 85;
      };
      plugin.prepend_previewers =
        let
          ouch = mime: {
            inherit mime;
            run = "ouch";
          };
        in
        [
          (ouch "application/*zip")
          (ouch "application/x-tar")
          (ouch "application/x-bzip2")
          (ouch "application/x-7z-compressed")
          (ouch "application/x-rar")
          (ouch "application/x-xz")
          (ouch "application/x-zstd")
          (ouch "application/xz")
          (ouch "application/zstd")
        ];
    };
  };

}
