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
  imports = [
    ../home-manager
    ./packages/dev-tools.nix
  ];

  options.modules.users.${username} = {
    enable = mkEnableOption "Enable user ${username} configuration";
  };

  config = mkIf (cfg.enable) (mkMerge [
    {
      programs.zsh.enable = true;
      users.users.chkpwd = {
        shell = pkgs.zsh;
      };
    }
  ]);
}
