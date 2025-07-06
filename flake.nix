{
  inputs.nixos-wsl.url = "github:nix-community/nixos-wsl";

  outputs = {
    nixpkgs,
    nixos-wsl,
    flake-utils,
    home-manager,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: {
      packages = let
        custom = {
          user = "alurm";
          email = "alan.urman@gmail.com";
          full-name = "Alan Urmancheev";

          state-version = "25.11";
        };
      in {
        homeConfigurations.${custom.user} = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [./home];
          extraSpecialArgs = {inherit custom;};
        };

        nixosConfigurations = {
          wsl = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              nixos-wsl.nixosModules.default

              ./wsl.nix
            ];
          };
        };
      };
    });
}
