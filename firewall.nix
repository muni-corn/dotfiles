{
  networking.firewall = {
    # ports for ssh and minecraft should be opened by their corresponding
    # configurations
    allowedTCPPorts = [
      10001
      9001

      # for development
      8080
    ];
  };
}
