{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./networking.nix
    ./home-manager.nix
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [
        "@admin"
        "${config.crossSystem.username}"
      ];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
    };
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  system.stateVersion = 5;
}
