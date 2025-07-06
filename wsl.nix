{custom, ...}: {
  wsl = {
    enable = true;
    defaultUser = custom.user;
  };

  system.stateVersion = custom.state-version;
  networking.hostName = "wsl";
  environment.variables.COLORTERM = "truecolor";
  nix.settings.experimental-features = "nix-command flakes";
  programs.fish.enable = true;
}
