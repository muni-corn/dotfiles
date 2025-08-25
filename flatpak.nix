{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.gnome-software ];

  services.flatpak.enable = true;

  systemd.services.flatpak-repo-config = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
