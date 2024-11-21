{ lib, pkgs, inputs, ... }:
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
    optimise.automatic = false; # https://github.com/LnL7/nix-darwin/pull/915#issuecomment-2165177905
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = false; # https://github.com/NixOS/nix/issues/7273
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
