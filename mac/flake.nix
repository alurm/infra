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

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [];
    };

    lib = pkgs.lib;
    enquote = lib.escapeShellArg;
    enpath = x: enquote (builtins.concatStringsSep "/" x);

    the = {
      system-dir = [ "Desktop" "System" ];
      full-name = "Alan Urmancheev";
      email = "alan.urman@gmail.com";
      username = "alurm";
    };
  in {
    home = import ./home.nix (the // { inherit lib enquote enpath; });

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
        yq-go
        exiftool
        eyed3
        moreutils
        imagemagick
        bat
        parallel
        fd

        go
        jq
        gawk
        cue
        ghc
        ghostscript
        nodejs

        nodePackages.tiddlywiki

        bash-language-server
        shfmt
        shellcheck

        nixfmt-rfc-style
        alejandra
        direnv
        nix-direnv
        nil

        (writeShellApplication {
          name = "nix2home";
          text = ''
            cd ~

            nix eval ~/${enpath the.system-dir}/infra/mac#home --json |
            ${json2dir.packages.${system}.default}/bin/json2dir
          '';
        })

        # This one is a bit complex but let's keep it this way for now.
        (writeShellApplication {
          name = "my-acme";
          text = ''
            PAGER=cat \
            SHELL=rc \
            EDITOR=E \
            TERM=dumb \
            NO_COLOR=1 \
            prompt=$'\n' \
            exec \
            acme \
            -a \
            "$@"
          '';
        })
      ];
    };
  };
}
