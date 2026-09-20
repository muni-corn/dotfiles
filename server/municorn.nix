{
  services.caddy.virtualHosts = {
    "municorn.me".extraConfig = ''
      import security_headers
      redir https://musicaloft.com/card temporary
    '';

    "muni.horse".extraConfig = ''
      import security_headers
      redir https://musicaloft.com/card temporary
    '';

    "municorn.horse".extraConfig = ''
      import security_headers
      redir https://musicaloft.com/card temporary
    '';
  };
}
