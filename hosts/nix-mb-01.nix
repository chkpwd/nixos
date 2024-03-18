{
  inputs,
  ...
}: {
  imports = [inputs.vscode-server.nixosModules.default];

  # Sudo Touch ID authentication
  security.pam.enableSudoTouchIdAuth = true;
}
