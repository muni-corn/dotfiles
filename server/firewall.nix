{ ... }:
let
  lanSubnet = "192.168.68.0/24";
in
{
  # sshd opens port 22 globally by default. the rules
  # below replace that with one scoped to the lan and the vpn.
  services.openssh.openFirewall = false;

  networking.firewall = {
    # vpn clients may use ssh and dns (adguard)
    interfaces.wg0 = {
      allowedTCPPorts = [
        22
        53
      ];
      allowedUDPPorts = [ 53 ];
    };

    # match on source address rather than interface: traffic the deco
    # port-forwards from the internet also arrives on enp4s0, but keeps its
    # public source address, so it won't match these rules
    extraInputRules = ''
      ip saddr ${lanSubnet} tcp dport { 22, 53 } accept
      ip saddr ${lanSubnet} udp dport { 53, 4002 } accept

      # dhcp clients have no source address yet (0.0.0.0), so match the interface
      iifname "enp4s0" udp dport 67 accept
    '';
  };
}
