{pkgs, username, ...}: {
  imports = [
    ./macos-defaults.nix
    ./networking.nix
  ];

  config = {
    nix = {
      package = pkgs.nix;
      settings.trusted-users = [ "@admin" "${username}" ];
    };

    services.nix-daemon.enable = true;

    security.pam.enableSudoTouchIdAuth = true;

    system.stateVersion = 4;
  };
}
