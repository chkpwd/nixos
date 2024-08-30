{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./macos-defaults.nix
    ./networking.nix
    ./home-manager.nix
  ];

  config = {
    nix = {
      package = pkgs.nix;
      settings = {
        trusted-users = ["@admin" "${username}"];
        extra-nix-path = "nixpkgs=flake:nixpkgs";
      };
    };

    services.nix-daemon.enable = true;

    security.pam.enableSudoTouchIdAuth = true;

    system.stateVersion = 4;
  };
}
