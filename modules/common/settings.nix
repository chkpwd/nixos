{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  environment.systemPackages = [
    pkgs.nil
    pkgs.nixd
  ];

  system.stateVersion = mkDefault "24.11";

  # Allow Proprietary software
  nixpkgs.config.allowUnfree = true;

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true; # thank you lix
      accept-flake-config = true;
      trusted-users = mkDefault [
        "root"
        "@wheel"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };
}
