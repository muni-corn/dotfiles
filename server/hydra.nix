{
  services = {
    hydra = {
      enable = true;
      buildMachinesFiles = [ ];
      hydraURL = "hydra.musicaloft.com";
      notificationSender = "hello@hydra.musicaloft.com";
      useSubstitutes = true;
      port = 49372;
      minimumDiskFree = 20;
      minimumDiskFreeEvaluator = 20;
    };
  };
}
