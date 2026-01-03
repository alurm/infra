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

    my = {
      system-dir = [ "Desktop" "System" ];
      full-name = "Alan Urmancheev";
      email = "alan.urman@gmail.com";
      username = "alurm";
    };
  in with my; {
    home = import ./home.nix (my // { inherit pkgs lib enquote enpath; });

    packages.${system}.default = with pkgs; symlinkJoin {
      name = "profile";
      paths =
      # Keep this in case I decide to use Emacs again.
      # 
      # (with emacs.pkgs; [
      #   vterm
      #   treesit-grammars.with-all-grammars
      #   nix-ts-mode
      # ]) ++
      [
        lsbig.packages.${system}.default
        json2dir.packages.${system}.default

        # Tools

        jujutsu
        atool
        rlwrap
        git

        ## Used rarely or niche
        
        bat
        ripgrep
        cloc
        entr
        exiftool
        eyed3
        moreutils
        imagemagick
        fd
        pandoc
        rclone
        parallel

        # Programming and configuration languages of sorts

        go
        lua5_4
        python3
        jq
        gawk
        cue
        ghc
        ghostscript
        nodejs

        # Python

        pyright
        (python3.withPackages (_: with _; [
          ipython
          requests
        ]))

        # Bash

        bash-language-server
        shfmt
        shellcheck

        # Nix

        direnv
        nix-direnv
        nil

        ## Don't remember which formatter is better, add both.

        nixfmt-rfc-style
        alejandra

        # JavaScript

        prettier

        (writeShellApplication {
          name = "nix2home";
          text = ''
            cd ~

            nix eval ~/${enpath system-dir}/nix/mac#home --json |
            ${json2dir.packages.${system}.default}/bin/json2dir
          '';
        })

      	# Keep TiddlyWiki stuff here for now in case I decide to use it again.
      	# 
        # HACK: these seemingly need to be in the store by TiddlyWiki service installed via json2dir.
        # Ideally, this shouldn't be required.
        # nodePackages.tiddlywiki

        # Keep this in case I decide to use Neovim.
        # 
        # (writeShellApplication {
        #   name = "o";
        #   text = ''
        #     exec open -a neovide "$@"
        #   '';
        # })

        # Keep this in case I decide to use Acme.
        # 
        # This one is a bit complex but let's keep it this way for now.
        # (writeShellApplication {
        #   name = "my-acme";
        #   text = ''
        #     PAGER=cat \
        #     SHELL=rc \
        #     EDITOR=E \
        #     TERM=dumb \
        #     NO_COLOR=1 \
        #     prompt=$'\n' \
        #     exec \
        #     acme \
        #     -a \
        #     "$@"
        #   '';
        # })
      ];
    };
  };
}
