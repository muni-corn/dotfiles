{
  config,
  lib,
  pkgs,
  ...
}:
{
  # until https://github.com/NixOS/nixpkgs/issues/388681 is solved
  nixpkgs.overlays = [
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          onnxruntime = python-prev.onnxruntime.overridePythonAttrs (oldAttrs: {
            buildInputs = lib.lists.remove pkgs.onnxruntime oldAttrs.buildInputs;
          });
        })
      ];
    })
  ];

  # until https://github.com/NixOS/nixpkgs/pulls/396478 is available
  systemd.services.taskchampion-sync-server.serviceConfig.ExecStart =
    let
      cfg = config.services.taskchampion-sync-server;
    in
    lib.mkForce ''
      ${lib.getExe cfg.package} \
        --listen "0.0.0.0:${builtins.toString cfg.port}" \
        --data-dir ${cfg.dataDir} \
        --snapshot-versions ${builtins.toString cfg.snapshot.versions} \
        --snapshot-days ${builtins.toString cfg.snapshot.days} \
        ${lib.concatMapStringsSep " " (id: "--allow-client-id ${id}") cfg.allowClientIds}
    '';
}
