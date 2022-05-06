{
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
}
