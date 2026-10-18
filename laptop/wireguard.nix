{ config, ... }:
let
  # munibot's wireguard public key
  munibotPublicKey = "bbDFjfq2Ltbe3/bLFIvnKYg51rv7lDZtDXmAwPO5YUM=";
in
{
  sops = {
    secrets.wireguard_private_key.sopsFile = ./secrets.yaml;

    # networkmanager substitutes $WG_PRIVATE_KEY into the profile below when it
    # is generated, so the key never lands in the nix store
    templates."networkmanager-wireguard.env".content = ''
      WG_PRIVATE_KEY=${config.sops.placeholder.wireguard_private_key}
    '';
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.templates."networkmanager-wireguard.env".path ];

    # the tunnel is on-demand, not always-on: at home, the lan is reachable
    # directly, and routing it through the tunnel would send lan traffic out
    # through the router and back. `nmcli connection up munibot` (or the same
    # over dbus) turns it on without root, because networkmanager allows
    # active local sessions to activate connections
    profiles.munibot = {
      connection = {
        id = "munibot";
        type = "wireguard";
        uuid = "9153c532-9b9b-4147-9995-231765ab6f9f";
        interface-name = "munibot";
        autoconnect = false;

        # only this user may activate it
        permissions = "user:muni:;";
      };

      wireguard.private-key = "$WG_PRIVATE_KEY";

      "wireguard-peer.${munibotPublicKey}" = {
        endpoint = "musicaloft.tplinkdns.com:51820";
        allowed-ips = "10.100.0.0/24;192.168.68.0/24;";
        persistent-keepalive = 25;
      };

      ipv4 = {
        method = "manual";
        address1 = "10.100.0.3/24";

        # answer musicaloft.com and municorn.me lookups from adguard on munibot
        # while the tunnel is up, so private-only hostnames resolve to the lan
        # address. the ~ makes these routing-only domains: nothing else is
        # sent through the tunnel
        dns = "192.168.68.70;";
        dns-search = "~musicaloft.com;~municorn.me;";
      };

      ipv6.method = "disabled";
    };
  };
}
