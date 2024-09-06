{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.local.sops;
in {
  options.local.sops = {
    enable = mkEnableOption "Enable SOPS on the host";

    file = {
      source = mkOption {
        type = types.path;
        default = false;
        description = "Source of age key file";
      };
    };

    age = {
      source = mkOption {
        type = types.path;
        default = false;
        description = "Source of age key file";
      };

      destination = mkOption {
        type = types.path;
        default = false;
        description = "Destination of age key file";
      };

      user = mkOption {
        type = types.str;
        default = config.crossSystem.username;
        description = "User for age key file";
      };

      group = mkOption {
        type = types.str;
        default = config.crossSystem.username;
        description = "Group for age key file";
      };
    };
  };

  imports = [inputs.sops-nix.nixosModules.sops];

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        age
        sops
      ];
      etc = {
        "${(strings.removePrefix "/etc/" cfg.age.destination)}" = {
          source = cfg.age.source;
          user = cfg.age.user;
          group = cfg.age.group;
        };
      };
    };

    sops = {
      validateSopsFiles = false;
      defaultSopsFile = cfg.file.source;
      age.keyFile = cfg.age.destination;
      secrets.chezmoi_token.owner = username;
    };
  };
}
