{
  services.caddy = {
    enable = true;
    email = "caddy@musicaloft.com";

    virtualHosts = {
      "municorn.me".extraConfig = ''
        redir https://musicaloft.com/card temporary
      '';

      "muni.horse".extraConfig = ''
        redir https://musicaloft.com/card temporary
      '';

      "municorn.horse".extraConfig = ''
        redir https://musicaloft.com/card temporary
      '';
    };
  };
}
