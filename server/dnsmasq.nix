{
  imports = [
    ../local-hosts.nix
  ];

  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
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
