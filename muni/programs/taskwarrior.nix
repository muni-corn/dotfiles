{ config, pkgs, ... }:
{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    config = {
      search.case.sensitive = "no";
      sync.server.url = "http://192.168.68.70:10222";

      # set default filter for taskwarrior-tui
      uda.taskwarrior-tui = {
        selection = {
          reverse = true;
          italic = true;
        };
        task-report.next.filter = "status:pending";
      };

      # remove news popup
      verbose = "affected,blank,context,edit,header,footnote,label,new-id,project,special,sync,override,recur";
    };
    extraConfig = ''
      include ${config.sops.secrets.taskwarrior_secrets.path}
    '';
  };

}
