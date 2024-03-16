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

  system.stateVersion = mkDefault "23.11";
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
      vim
    ];
    variables.EDITOR = mkDefault "nano"; #TODO: change to vim
  };

  networking.hostName = mkDefault "nixos";
  time.timeZone = mkDefault "America/New_York";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  services = {
    openssh = mkDefault {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  # Allow Proprietary software
  nixpkgs.config.allowUnfree = true;

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
}
