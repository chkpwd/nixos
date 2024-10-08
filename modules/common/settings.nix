{lib, ...}: let
  inherit (lib) mkDefault;
in {
  system.stateVersion = mkDefault "24.05";

  # Allow Proprietary software
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = false; # https://github.com/LnL7/nix-darwin/pull/915#issuecomment-2165177905
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = false; # https://github.com/NixOS/nix/issues/7273
      accept-flake-config = true;
      trusted-users = mkDefault ["root" "@wheel"];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
