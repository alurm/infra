{
  pkgs,
  lib,
  enquote,
  enpath,

  username,
  full-name,
  email,
  system-dir,
}:
{
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

  # Keep this in case I want to use Neovim.
  nvim."init.lua" = builtins.readFile ./neovim/init.lua;

  # Keep this in case I want to use Emacs.
  emacs."init.el" = builtins.readFile ./emacs/init.el;

  fish = {
    functions."fish_prompt.fish" = ''
      function fish_prompt
        echo
        echo
      end
    '';

    "config.fish" =
      let
        plan9 = ''
          # Plan 9 configuration

          set --export PLAN9 ~/Desktop/System/plan9port

          # Use the default MacOS monospace font.
          set --export font /mnt/font/Menlo-Regular/15a/font

          set --export prompt \n

          # End of Plan 9 configuration
        '';

        # Keep this in case I want to use Ki.
        ki-editor = ''
          # Ki Editor configuration
          
          set --export KI_EDITOR_THEME 'Mqual Blue'

          # End of Ki Editor configuration
        '';
      in
      ''
        if status is-login
          cd ~/Desktop

          # To-do: should this be set somehow differently?
          set --export fish_greeting '''

          set --export EDITOR hx

          ${ki-editor}

          ${plan9}

          # Set somewhere else, apparently, not needed.
          # set --export --prepend PATH ~/.nix-profile/bin

          set --export --append PATH \
            '/Applications/Visual Studio Code.app/Contents/Resources/app/bin' \
            /Applications/Emacs.app/Contents/MacOS \
            $PLAN9/bin \
            ~/go/bin \
            ${pkgs.nodePackages.tiddlywiki}/bin \
          ;
        end
      '';
  };

  direnv.direnvrc = ''
    source ~/.nix-profile/share/nix-direnv/direnvrc
  '';

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
