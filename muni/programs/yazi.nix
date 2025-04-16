{ pkgs, ... }:
{
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
          run = ''shell -- ${pkgs.dragon-drop}/bin/dragon-drop -x -T "$1"'';
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

}
