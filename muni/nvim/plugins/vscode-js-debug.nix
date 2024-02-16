{
  pkgs,
  vscode-js-debug-src,
  ...
}: let
  packageLock = builtins.fromJSON (builtins.readFile "${vscode-js-debug-src}/package.json");
  pname = packageLock.name;
  version = packageLock.version;
  vscode-js-debug = pkgs.buildNpmPackage {
    inherit pname version;
    src = vscode-js-debug-src;
    npmBuildScript = "compile";
    npmDepsHash = "sha256-RrFjHH6o4Q0VJpoKl6iufmUoG3AzJPSkgBMIo8oDrSs=";
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
