{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./networking.nix
    ./home-manager.nix
    inputs.nh-darwin.nixDarwinModules.prebuiltin
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = ["@admin" "${config.crossSystem.username}"];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
    };
  };

  environment = {
    shells = [pkgs.bashInteractive];
    shellAliases.nh = "nh-darwin";
    #variables.EDITOR = "${lib.getBin pkgs.neovim}/bin/nvim";
  };

  programs = {
    nh = {
      enable = true;
      #flake = "/h";
      # Installation option once https://github.com/LnL7/nix-darwin/pull/942 is merged:
      # package = nh-darwin.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
  };

  services.nix-daemon.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  system.stateVersion = 4;
}
