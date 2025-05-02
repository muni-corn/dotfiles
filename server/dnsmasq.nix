{
  networking.hosts."127.0.0.1" = [
    "ai.musicaloft.com"
    "cloud.musicaloft.com"
    "git.musicaloft.com"
    "watch.musicaloft.com"
    "munibot"
    "ssh.muni.bot"
  ];

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
