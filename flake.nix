{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.hotpocket = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./laptop-configuration.nix ];
    };
    nixosConfigurations.ponytower = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./desktop-configuration.nix ];
    };
  };
}
