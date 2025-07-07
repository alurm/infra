{
  pkgs,
  custom,
  ...
}: {
  home = {
    stateVersion = custom.state-version;
    username = custom.user;
    homeDirectory = "/home/${custom.user}";
    packages = with pkgs; [
      alejandra
      rlwrap
      nixd
      atool
      xclip
      unzip
      fd
    ];
    # file = {};
    sessionVariables = {
      EDITOR = "micro";
    };
  };

  programs = {
    home-manager.enable = true;

    jujutsu = {
      enable = true;
      settings =
        builtins.fromTOML (builtins.readFile jj/config.toml)
        // {
          user = {
            name = custom.full-name;
            email = custom.email;
          };
        };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Note: at the moment of writing,
    # Helix doesn't have a workspace security system:
    # https://github.com/helix-editor/helix/issues/2697
    # helix = {
    #   enable = true;
    #   defaultEditor = true;
    #   settings = builtins.fromTOML (builtins.readFile helix/config.toml);
    #   languages = builtins.fromTOML (builtins.readFile helix/languages.toml);
    # };

    # TODO: consider reverting to Helix once it has a workspace security system.
    micro.enable = true;

    fish = {
      enable = true;
      loginShellInit = ''
        set --export SHELL (which fish)
        set --export fish_greeting ${"''"}
      '';
    };

    git = {
      enable = true;
      userEmail = custom.email;
      userName = custom.full-name;
      extraConfig.init.defaultBranch = "main";
    };

    tmux = {
      enable = true;
      mouse = true;
      escapeTime = 0;
      terminal = "tmux-256color";
      extraConfig = ''
        # This seems to fix bad colors, for example in Helix.
        # Not sure how it works.
        set -g terminal-overrides ',*-256color:Tc'
        set -g terminal-overrides ",xterm*:Tc"
      '';
      # shortcut = "j";
    };
  };
}
