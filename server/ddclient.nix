{ config, ... }:
{
  # keeps a.musicaloft.com pointed at the home connection's public address.
  # every public hostname is a cname to it. this replaces the deco's tp-link
  # ddns name, whose nameservers answer nxdomain for aaaa lookups on a name
  # that exists, which made certificate authorities fail to resolve our names
  services.ddclient = {
    enable = true;
    protocol = "namecheap";

    # for namecheap, the login is the zone and the domain is the host in it
    username = "musicaloft.com";
    domains = [ "a" ];

    # the module copies this into its runtime config from a root pre-start
    # step, so the default root-only secret permissions are fine
    passwordFile = config.sops.secrets.ddclient_password.path;

    # ipv4 only: the router doesn't forward ipv6 to munibot, so publishing an
    # aaaa record would advertise an address that can't be reached
    usev6 = "";
  };
}
