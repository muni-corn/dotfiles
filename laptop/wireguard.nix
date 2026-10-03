{ config, ... }:
{
  sops.secrets.wireguard_private_key.sopsFile = ./secrets.yaml;

  # the tunnel is on-demand (`systemctl start wg-quick-munibot`), not always-on:
  # at home, the lan is reachable directly, and routing it through the tunnel
  # would send lan traffic out through the router and back
  networking.wg-quick.interfaces.munibot = {
    address = [ "10.100.0.3/24" ];
    autostart = false;
    dns = [ "192.168.68.70" ];
    privateKeyFile = config.sops.secrets.wireguard_private_key.path;

    peers = [
      {
        publicKey = "bbDFjfq2Ltbe3/bLFIvnKYg51rv7lDZtDXmAwPO5YUM=";
        endpoint = "musicaloft.tplinkdns.com:51820";
        allowedIPs = [
          "10.100.0.0/24"
          "192.168.68.0/24"
        ];
        persistentKeepalive = 25;
      }
    ];
  };
}
