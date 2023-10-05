{
  programs.nixvim.plugins.which-key = {
    enable = true;
    icons.separator = "󰅂";
    layout.align = "center";
    triggersBlacklist.i = ["f" "j" "<c-j>" "<c-h>" "{" "[" "("];
    window.border = "single";

    registrations = {

    };
  };
}
