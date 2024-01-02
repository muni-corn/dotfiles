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
    npmDepsHash = "sha256-0IMg70XJphcSX/bist9Ak/tygLuK4QuzL/UzMqLc/B0=";
    makeCacheWritable = true;
    patches = [ ./vscode-js-debug-remove-playwright.patch ];
    nativeBuildInputs = with pkgs; [ pkg-config ];
    buildInputs = with pkgs; [ libsecret ];
  };
in {
  programs.nixvim.extraPlugins = [
    vscode-js-debug
  ];
}
