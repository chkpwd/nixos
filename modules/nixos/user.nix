{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.user-config;
in {
  imports = [../common/packages];

  options.mainUser = {
    username = mkOption {
      type = nullOr str;
      default = "chkpwd";
      description = "Username for the main user";
    };
    email = mkOption ...;
    fullName = mkOption ...;
  };

  config = mkIf (cfg.enable) {
    users.users.${config.mainUser.username} = {
      isNormalUser = true;
      extraGroups = mkDefault ["wheel"];
      shell = mkForce pkgs.zsh;
      hashedPassword = mkDefault "$2a$10$Twk912seoPb5076byIfjI.IiQ2STRrREwp3hkqUaOLlzYruSXGMuq";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBK2VnKgOX7i1ISETheqjAO3/xo6D9n7QbWyfDAPsXwa" ];
    };

    security.sudo.extraRules = [
      {
        users = mkDefault [username];
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
