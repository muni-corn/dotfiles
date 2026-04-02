{
  networking.firewall = {
    # ports for ssh and minecraft should be opened by their corresponding
    # configurations
    allowedTCPPorts = [
      # for development
      8080
    ];
  };
}
