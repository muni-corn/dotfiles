{
  imports = [
    ./hyprland.nix
    ./muni.nix
    ./nix-community.nix
  ];

  nix.settings = {
    trusted-substituters = ["https://ai.cachix.org"];
    trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];
  };
}
