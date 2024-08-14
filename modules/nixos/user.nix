{
  lib,
  config,
  username,
  sshPubKey,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.users.${username};
in {
  imports = [ ../common/packages ];

  options.local.users.${username} = {
    enable = mkEnableOption "Enable user configuration";

    noPasswd = mkOption {
      type = types.bool;
      default = false;
      description = "No Password for sudoers";
    };   
  };

  config = mkIf (cfg.enable) {
    users.users.${username} = {
      isNormalUser = optional true;
      home = mkDefault "/home/${username}";
      extraGroups = optional [ "wheel" ];
      shell = mkDefault pkgs.zsh;
      openssh.authorizedKeys.keys = [ sshPubKey ];
    };

    programs.zsh.enable = true;

    security.sudo = mkIf (cfg.noPasswd == true) {
      extraRules = [
        {
          users = [ "${username}" ];
          runAs = "ALL:ALL";
          commands = [
            {
              command = "ALL";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}

