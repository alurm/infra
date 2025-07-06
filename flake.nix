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
        homeConfigurations = let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          ${custom.user} = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [./home];
            extraSpecialArgs = {inherit custom;};
          };
        };
        nixosConfigurations = {
          wsl = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              nixos-wsl.nixosModules.default

              {
                wsl = {
                  enable = true;
                  defaultUser = custom.user;
                };

                system.stateVersion = custom.state-version;
                networking.hostName = "wsl";
                environment.variables.COLORTERM = "truecolor";
                nix.settings.experimental-features = "nix-command flakes";
                programs.fish.enable = true;
              }
            ];
          };
        };
      };
    });
}
