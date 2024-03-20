{
  lib,
  config,
  username,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.users.${username};
in {
  imports = [./packages];
  options.modules.users.${username} = {
    enable = mkEnableOption "Enable user ${username} configuration";
  };

  config = mkIf (cfg.enable) {
    programs.zsh.enable = true;
    users.users.chkpwd = {
      shell = pkgs.zsh;
    };
  };
}
