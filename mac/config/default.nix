my @ {
  pkgs,
  lib,
  enquote,
  enpath,

  username,
  full-name,
  email,
  system-dir,
}: {
      git = {
        config = ''
          [init]
          defaultBranch = main

          [user]
          name = ${full-name}
          email = ${email}
        '';
        ignore = ''
          .DS_Store
        '';
      };

      jj."config.toml" = ''
        "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

        [user]
        name = "${full-name}"
        email = "${email}"

        [ui]
        diff-editor = ":builtin"
        default-command = ["log", "-r", "all()"]

        [git]
        colocate = true
      '';

      nvim = {
        "init.lua" = builtins.readFile ./neovim/init.lua;
      };

      fish = {
        functions."fish_prompt.fish" = ''
          function fish_prompt
            echo
            echo
          end
        '';

        "config.fish" = ''
          if status is-login
            cd Desktop

            # To-do: this should be somewhere else?
            set --export fish_greeting '''

            # Seems potentially unnecessary.
            # set --export --prepend PATH ~/.nix-profile/bin

            set --export EDITOR ed

            set --export PLAN9 ~/Desktop/System/plan9port

            # Use the default MacOS monospace font.
            set --export font /mnt/font/Menlo-Regular/15a/font

            set --export --append PATH \
              '/Applications/Visual Studio Code.app/Contents/Resources/app/bin' \
              /Applications/Emacs.app/Contents/MacOS \
              $PLAN9/bin \
              ~/go/bin \
              ${pkgs.nodePackages.tiddlywiki}/bin \
            ;

            # Plan 9

            set --export prompt \n

            # End of Plan 9
          end
        '';
      };

      direnv.direnvrc = ''
        source ~/.nix-profile/share/nix-direnv/direnvrc
      '';

      # Keep this in case I decide to use Helix again.
      helix = {
        "config.toml" = ''
          theme = "vim_dark_high_contrast"

          [editor]
          auto-pairs = false
          insert-final-newline = false

          [editor.file-picker]
          hidden = false

          [editor.soft-wrap]
          enable = true
        '';

        "languages.toml" = ''
          [language-server.rust-analyzer.config]
          check.command = "clippy"
        '';
      };
    }
