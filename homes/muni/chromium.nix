{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    dictionaries = [
      pkgs.hunspellDictsChromium.en_US
    ];
    extensions = [
      {id = "ajopnjidmegmdimjlfnijceegpefgped";} # betterttv
      {id = "naepdomgkenhinolocfifgehidddafch";} # browserpass
      {id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";} # dark reader
      {id = "nkbihfbeogaeaoehlefnkodbefgpgknn";} # metamask
      {id = "inpoelmimmiplkcldmdljiboidfkcfbh";} # presearch
      {id = "bpaoeijjlplfjbagceilcgbkcdjbomjd";} # ttv lol pro
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
      {id = "dbepggeogbaibhgnhhndojpepiihcmeb";} # vimium
    ];
  };
}
