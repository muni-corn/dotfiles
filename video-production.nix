{ pkgs, ... }:
{
  home-manager.users.muni.home.packages = with pkgs; [
    blender-hip
    kdePackages.kdenlive
    movit
    synfigstudio
  ];

  # for Blender
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
}
