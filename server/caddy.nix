{
  services.caddy = {
    enable = true;
    email = "caddy@musicaloft.com";

    # reusable snippets, imported by individual vhosts below
    extraConfig = ''
      (security_headers) {
        header {
          # force https for a year, including subdomains
          Strict-Transport-Security "max-age=31536000; includeSubDomains"

          # only set these if the backend hasn't already opinionated on them
          ?X-Content-Type-Options "nosniff"
          ?Referrer-Policy "strict-origin-when-cross-origin"
          ?X-Frame-Options "SAMEORIGIN"

          # stop leaking backend server details
          -Server
        }
      }
    '';
  };
}
