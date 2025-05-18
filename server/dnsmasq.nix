{
  networking = {
    firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 ];
    };
    hosts = {
      "192.168.68.70" = [
        "ai.musicaloft.com"
        "cache.musicaloft.com"
        "cloud.musicaloft.com"
        "git.musicaloft.com"
        "munibot"
        "musicaloft.tplinkdns.com"
        "nixbld.musicaloft.com"
        "ssh.muni.bot"
        "watch.musicaloft.com"
      ];

      "192.168.68.60" = [
        "breezi-brigantine"
        "pc.ssh.muni.bot"
      ];

      "192.168.68.80" = [
        "cherri-compass"
        "lp.ssh.muni.bot"
      ];
    };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      bogus-priv = true;
      cache-size = 10000;
      domain-needed = true;
      server = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
  };
}
