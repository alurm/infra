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
  # Keep this in case I want to use Neovim.
  nvim."init.lua" = builtins.readFile ./neovim/init.lua;

  # Keep this in case I want to use Emacs.
  emacs."init.el" = builtins.readFile ./emacs/init.el;

  wezterm."wezterm.lua" = builtins.readFile ./wezterm/wezterm.lua;

  fish = import ./fish pkgs;

  direnv.direnvrc = ''
    source ~/.nix-profile/share/nix-direnv/direnvrc
  '';

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

      [[language]]
      name = "nix"
      formatter = { command = "alejandra" }
    '';
  };
}
