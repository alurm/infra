{
  inputs.lsbig.url = "github:alurm/lsbig";

  outputs = {
    nixpkgs,
    flake-utils,
    lsbig,
    ...
  }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.default = pkgs.symlinkJoin {
      name = "my-profile";
      paths = with pkgs; [
        helix
        jujutsu
        treefmt
        nixfmt-rfc-style
        fish
        atool
        direnv
        nix-direnv
        sqlite
        rlwrap
        zig
        lsbig.packages.${system}.default
      ];
    };
  });
}
