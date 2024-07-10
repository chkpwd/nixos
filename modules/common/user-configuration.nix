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
  imports = [./packages];
  options.local.users.${username} = {
    enable = mkEnableOption "Enable user configuration";
  };

  config = mkIf (cfg.enable) {
    users.users.${username} = {
      isNormalUser = true;
      home = "/home/${username}";
      extraGroups = ["wheel"];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [sshPubKey];
    };
    programs.zsh.enable = true;
    security.sudo.extraRules = [
      {
        users = ["user"];
        runAs = "ALL:ALL";
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
