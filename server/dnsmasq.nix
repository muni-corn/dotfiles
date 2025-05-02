{
  networking.hosts = {
    "127.0.0.1" = [
      "ai.musicaloft.com"
      "cache.musicaloft.com"
      "cloud.musicaloft.com"
      "git.musicaloft.com"
      "watch.musicaloft.com"
      "nixbld.musicaloft.com"
      "munibot"
      "ssh.muni.bot"
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
