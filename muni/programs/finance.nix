{ config, pkgs, ... }:
{
  home = {
    sessionVariables = {
      RLEDGER_FILE = "${config.home.homeDirectory}/notebook/ledger/main.beancount";
    };

    packages = with pkgs; [
      bc
      entr

      # plain-text accounting
      hledger
      hledger-fmt
      ledger2beancount
      ledger-autosync
      rustfava
      puffin

      # pdf to csv
      tabula-java

      # xlsx to csv
      xlsx2csv
    ];
  };
}
