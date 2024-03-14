{
  programs.starship = {
    enable = true;
    settings = {
      format = ''$all$shell$jobs$status$character'';

      battery.display = [
        {
          threshold = 15;
          style = "bold red";
        }
        {
          threshold = 30;
          style = "bold yellow";
        }
      ];

      # don't you dare enable cmd_duration notifications
      # you'll regret it
      # (it is handled by a fish plugin that shows which command was run and
      # doesn't show notifications if the window is focused)

      memory_usage = {
        disabled = false;
      };
      package = {
        disabled = true;
      };
      status = {
        disabled = false;
        symbol = "• ";
      };
    };
  };
}
