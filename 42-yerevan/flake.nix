{
  outputs = {
    nixpkgs,
    flake-utils,
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
      ];
    };
  });
}
