{pkgs, ...}: {
  imports = [./macos-defaults.nix];

  config = {
    nix.gc.interval = {
      Hour = 12;
      Minute = 15;
      Day = 1;
    };

    services.nix-daemon.enable = true;

    security.pam.enableSudoTouchIdAuth = true;

    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
 
    system.stateVersion = 4;
  };
}
