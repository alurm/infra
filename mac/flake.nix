{
  inputs = {
    lsbig.url = "github:alurm/lsbig";
    json2dir.url = "github:alurm/json2dir";
  };
  
  outputs = {
    nixpkgs,
    lsbig,
    json2dir,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    home = import ./home.nix;
    packages.${system}.default = with pkgs; symlinkJoin {
      name = "profile";
      paths = [
        lsbig.packages.${system}.default
        json2dir.packages.${system}.default
        helix
        fish
        jujutsu
        atool
        rlwrap
        ripgrep
        cloc
        git
        cue
        entr
        go
        jq
        yq-go

        bash-language-server
        shfmt
        shellcheck

        nixfmt-rfc-style
        direnv
        nix-direnv
        nil

        (writeShellScriptBin "nix2home" ''
          cd ~ || exit 1
          nix eval ~/My/infra/mac#home --json | ${json2dir.packages.${system}.default}/bin/json2dir || exit 1
        '')
      ];
    };
  };
}
