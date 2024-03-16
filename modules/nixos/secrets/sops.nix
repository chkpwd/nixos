{
  pkgs,
  config,
  username,
  inputs,
  lib,
  ...
}: let
  cfg = config.custom.sops;
in {
  options.custom.sops = {
    enable = lib.mkEnableOption "Enable SOPS on the host";

    file = {
      source = lib.mkOption {
        type = lib.types.path;
        default = false;
        description = "Source of age key file";
      };
    };

    age = {
      source = lib.mkOption {
        type = lib.types.path;
        default = false;
        description = "Source of age key file";
      };
      destination = lib.mkOption {
        type = lib.types.path;
        default = false;
        description = "Destination of age key file";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = config.users.users.${username}.name;
        description = "User for age key file";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = config.users.users.${username}.group;
        description = "Group for age key file";
      };
    };
  };

  imports = [inputs.sops-nix.nixosModules.sops];

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        age
        sops
      ];
      etc = {
        "${(lib.strings.removePrefix "/etc/" cfg.age.destination)}" = {
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
