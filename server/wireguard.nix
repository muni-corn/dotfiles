{ config, ... }:
{
  networking = {
    firewall.allowedUDPPorts = [ 51820 ];

    # lets wg clients reach the whole lan, not just munibot itself, since the
    # deco mesh can't add a static route to the wg subnet
    nat = {
      enable = true;
      internalInterfaces = [ "wg0" ];
      externalInterface = "enp4s0";
    };

    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.sops.secrets.wireguard_private_key.path;

      # phone isn't added yet; its public key will land in a follow-up commit
      peers = [
        {
          name = "breezi";
          publicKey = "qH/vjLm+Fh8y1dFzbLmKyCYS9CXlaH/lKNDTkLDAll4=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          name = "cherri";
          publicKey = "lGaNT9cb0k3MNq3mxK43oIjClUVB/UNX4YU3F7T/ewM=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
}
