{ ... }:
{
  enable = true;
  settings = {
    format = ''$all$shell$jobs$status$character'';
    battery = {
      display.threshold = 30;
    };
    memory_usage = {
      disabled = false;
    };
    package = {
      disabled = true;
    };
    status = {
      disabled = false;
      symbol = "•";
    };
  };
}
