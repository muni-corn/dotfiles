{
  pkgs,
  inputs,
  ...
}: let
  packageLock = builtins.fromJSON (builtins.readFile "${inputs.vscode-js-debug}/package.json");
  pname = packageLock.name;
  version = packageLock.version;
  vscode-js-debug = pkgs.buildNpmPackage {
    inherit pname version;
    src = inputs.vscode-js-debug;
    npmBuildScript = "compile";
    npmDepsHash = "sha256-BDtshWHWFasb+aYUBRFz8OAP+9Ufh5uy3XNZCQOY79U=";
    npmBuildFlags = ["dapDebugServer"];
    makeCacheWritable = true;
    patches = [./vscode-js-debug-remove-playwright.patch];
    nativeBuildInputs = with pkgs; [pkg-config];
    buildInputs = with pkgs; [libsecret];
    installPhase = ''
      mkdir $out
      mv dist/ $out/
    '';
  };
in {
  programs.nixvim = {
    plugins.dap.adapters.servers.pwa-node = {
      host = "localhost";
      port = "\${port}";
      executable = {
        command = "node";
        args = [
          "${vscode-js-debug}/dist/src/dapDebugServer.js"
          "\${port}"
        ];
      };
    };

    extraPlugins = [
      vscode-js-debug
    ];
  };
}
