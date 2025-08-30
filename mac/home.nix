let
  full-name = "Alan Urmancheev";
  email = "alan.urman@gmail.com";
in
{
  Library."Application Support"."com.mitchellh.ghostty".config = ''
    # To avoid a flick at load.
    cursor-style = block_hollow

    cursor-style-blink = false

    # It's not obvious how to do maximized properly at the moment.
    window-save-state = always

    command = bash -l -c 'exec ~/.nix-profile/bin/fish -l'

    macos-option-as-alt = true
  '';
  
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

      [git]
      colocate = true
    '';

    fish."config.fish" = ''
      if status is-interactive && status is-login
        set --export fish_greeting '''
        set --export SHELL (which fish)
        set --export EDITOR hx
        set --export --append PATH '/Applications/Visual Studio Code.app/Contents/Resources/app/bin'

        if [ (pwd) = ~ ]
          cd My/current
        end
      end
    '';

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
  };
}
