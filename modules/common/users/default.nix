{
  lib,
  config,
  username,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.users.${username};
in {
  imports = [./packages];
  options.local.users.${username} = {
    enable = mkEnableOption "Enable user ${username} configuration";
  };

  config = mkIf (cfg.enable) {
    programs.zsh.enable = true;
    users.users.chkpwd = {
      shell = pkgs.zsh;
    };
  };
}
