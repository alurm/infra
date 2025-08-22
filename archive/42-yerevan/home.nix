let
  full-name = "Alan Urmancheev";
  email = "alan.urman@gmail.com";
in
{
  ".config" = {
    git.config = ''
      [init]
      defaultBranch = main

      [user]
      name = ${full-name}
      email = ${email}
    '';

    jj."config.toml" = ''
      "$schema" = "https://jj-vcs.github.io/jj/latest/config-schema.json"

      [user]
      name = "${full-name}"
      email = "${email}"

      [ui]
      diff-editor = ":builtin"
      default-command = ["log", "-r", "all()"]
    '';

    fish."config.fish" = ''
      if status is-interactive && status is-login
        set --export fish_greeting '''
        set --export PATH ~/goinfre/nixsa/bin $PATH

        # For some reason (which fish) doesn't work with tmux.
        set --export SHELL ~/goinfre/nixsa/state/profile/bin/fish
        set --export EDITOR hx

        if [ (pwd) = ~ ]
          cd my
        end
      end
    '';

    direnv.direnvrc = ''
      source "$NIX_STATE_HOME/profile/share/nix-direnv/direnvrc"
    '';

    tmux."tmux.conf" = ''
      set -g mouse on
      set -g escape-time 0
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
  };
}
