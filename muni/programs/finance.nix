{ pkgs, ... }:
{

  home.packages = with pkgs; [
    bc
    entr

    # plain-text accounting
    hledger
    hledger-fmt
    rustledger
    ledger-autosync
    puffin

    # pdf to csv
    tabula-java

    # xlsx to csv
    xlsx2csv
  ];
}
