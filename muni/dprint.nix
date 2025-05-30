{ pkgs, ... }:
let
  config = {
    plugins =
      with pkgs;
      dprint-plugins.getPluginList (
        plugins: with dprint-plugins; [
          dprint-plugin-toml
          dprint-plugin-markdown
          dprint-plugin-json
          dprint-plugin-typescript
          dprint-plugin-biome
          g-plane-malva
          g-plane-markup_fmt
        ]
      );
    excludes = [
      "**/*-lock.json"
      "**/node_modules"
    ];
    markdown = {
      textWrap = "always";
      "emphasisKind" = "asterisks";
    };
    lineWidth = 80;
    indentWidth = 2;
    useTabs = false;
  };
in
{
  home.file.".dprint.jsonc".text = builtins.toJSON config;
}
