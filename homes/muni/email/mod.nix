{ config, ... }:

{
  maildirBasePath = "${config.home.homeDirectory}/.mail";
  accounts = {
    work = import ../secret/gmail_work.nix;
    protonmail = import ../secret/protonmail.nix;
  };
}
