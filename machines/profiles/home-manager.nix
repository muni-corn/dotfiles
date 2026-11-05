# wires muni's home-manager configuration into the system. `inputs` comes from
# the machine's specialArgs and is passed along to home-manager modules
{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    overwriteBackup = true;
    useGlobalPkgs = true;
    useUserPackages = true;
    users.muni = ../../muni;
  };
}
