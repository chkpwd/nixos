{
  lib,
  config,
  username,
  sshPubKey,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.user-config;
  userData = import ../common/user-data.nix;
in {
  imports = [../common/packages];

  options.local.user-config = {
    enable = mkEnableOption "Enable user configuration";

    username = mkEnableOption {
      type = types.str;
      default = userData.username;
      description = "Username for the user";
    };

    # nonAdmin = mkEnableOption {
    #   type = types.bool;
    #   default = true;
    #   description = "User is not an admin";
    # };
    #

    # noPasswd = mkOption {
    #   type = types.bool;
    #   default = false;
    #   description = "No Password for sudoers";
    # };
  };

  config = mkIf (cfg.enable) {
    users.users.${userData.username} = {
      isNormalUser = true;
      home = mkDefault "/home/${userData.username}";
      extraGroups = mkDefault ["wheel"];
      shell = mkForce pkgs.zsh;
      hashedPassword = mkDefault "$2a$10$Twk912seoPb5076byIfjI.IiQ2STRrREwp3hkqUaOLlzYruSXGMuq";
      openssh.authorizedKeys.keys = [sshPubKey];
    };

    security.sudo.extraRules = [
      {
        users = mkDefault ["${userData.username}"];
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    programs.zsh.enable = true;
  };
}
