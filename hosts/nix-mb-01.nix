{inputs, ...}: {
  imports = [inputs.vscode-server.nixosModules.default];

  nix.gc.interval = {
    Weekday = 0;
    Hour = 2;
    Minute = 0;
  };

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  # Sudo Touch ID authentication
  security.pam.enableSudoTouchIdAuth = true;
}
