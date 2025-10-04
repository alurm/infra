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
        jujutsu
        atool
        rlwrap
        ripgrep
        cloc
        git
        entr
        go
        jq
        yq-go
        exiftool
        eyed3
        jq
        gawk
        moreutils
        imagemagick
        cue

        bash-language-server
        shfmt
        shellcheck

        nixfmt-rfc-style
        direnv
        nix-direnv
        nil

        (writeShellApplication {
          name = "nix2home";
          text = ''
            cd ~

            nix eval ~/My/system/infra/mac#home --json |
            ${json2dir.packages.${system}.default}/bin/json2dir
          '';
        })
      ];
    };
  };
}
