{ ... }:
{
  enable = true;
  settings = {
    format = ''$all$shell$jobs$status$character'';
    battery = {
      display.threshold = 30;
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
