{
  lib,
  pkgs,
  inputs,
  username,
  sshPubKey,
  ...
}:
with lib; {
  imports = [inputs.home-manager.nixosModules.default];

  system.stateVersion = mkDefault "23.11"; # TODO: Look into lib.mkDefault lib.mkOverride lib.mkForce
  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [sshPubKey];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      nil
      alejandra
    ];
    pathsToLink = ["/share/zsh"];
    shells = [pkgs.zsh];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
      accept-flake-config = true;
      trusted-users = ["root" "@wheel"];
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  # Allow Proprietary software
  nixpkgs.config.allowUnfree = true;
}
