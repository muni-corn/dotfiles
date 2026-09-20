{
  services.caddy.virtualHosts."mc.muni.horse".extraConfig = ''
    import security_headers
    reverse_proxy 127.0.0.1:25565
    header Host mc.muni.horse
  '';
}
