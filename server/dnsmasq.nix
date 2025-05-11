{
  networking.hosts = {
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
      "ponycastle"
    ];

    "192.168.68.80" = [
      "littlepony"
    ];
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
