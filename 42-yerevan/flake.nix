{
  inputs.lsbig.url = "github:alurm/lsbig";
  inputs.json2dir.url = "github:alurm/json2dir";

  outputs =
    {
      nixpkgs,
      flake-utils,
      lsbig,
      json2dir,
      home-manager,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {

m3 = pkgs.symlinkJoin {

name = "profile";

paths = with pkgs; [

lsbig.packages.${system}.default
json2dir.packages.${system}.default
helix
fish

];

};

          fourty-two = pkgs.symlinkJoin {
            name = "my-profile";
            paths = with pkgs; [
              lsbig.packages.${system}.default
              json2dir.packages.${system}.default

              helix

              telegram-desktop
              jujutsu
              treefmt
              atool
              sqlite
              rlwrap
              ripgrep
              fd
              scdoc
              curl
              util-linux
              cloc
              s6-portable-utils

              fish
              zig
              lua
              es

              execline
              execline-man-pages

              bash-language-server
              shfmt
              shellcheck

              nixfmt-rfc-style
              direnv
              nix-direnv
              nil

              clang-tools

              (writeShellScriptBin "apply-my-profile-and-dotfiles" ''
                nix profile upgrade 42-yerevan || exit 1
                apply-my-dotfiles || exit 1
              '')

              (writeShellScriptBin "apply-my-dotfiles" ''
                cd || exit 1
                nix eval ~/my/infra/42-yerevan#home --json | json2dir || exit 1
              '')
            ];
          };
        };
      }
    )
    // {
      home = import ./home.nix;
    };
}
