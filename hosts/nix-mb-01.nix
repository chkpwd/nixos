{inputs, ...}: {
  # Enable Nix Daemon
  nix.useDaemon = true;

  # Sudo Touch ID authentication
  security.pam.enableSudoTouchIdAuth = true;
}
