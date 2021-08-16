{ config, ... }:

{
  maildirBasePath = "${config.home.homeDirectory}/.mail";
  accounts = {
    work = import ./gmail_work.nix;
    protonmail = import ./protonmail.nix;
  };
}
