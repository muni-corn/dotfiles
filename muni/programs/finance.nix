{ pkgs, ... }:
{

  home.packages = with pkgs; [
    entr

    # plain-text accounting
    hledger
    hledger-fmt
    ledger-autosync
    puffin

    # pdf to csv
    tabula-java

    # xlsx to csv
    xlsx2csv
  ];
}
