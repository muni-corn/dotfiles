{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cameractrls-gtk4
    zoom-us
    ffmpeg-full
  ];

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 5959;
        to = 5969;
      }
      {
        from = 6960;
        to = 6970;
      }
      {
        from = 7960;
        to = 7970;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 5959;
        to = 5969;
      }
      {
        from = 6960;
        to = 6970;
      }
      {
        from = 7960;
        to = 7970;
      }
    ];
    allowedTCPPorts = [ 5960 ];
    allowedUDPPorts = [ 5353 ];
  };

  services.avahi.enable = true;
}
