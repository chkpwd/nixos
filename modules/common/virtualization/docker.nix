{
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.modules.docker;
in {
  options.modules.docker = {
    enable = mkEnableOption "Enable Docker on the host";
  };
  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = mkDefault false;
      };
    };
    users.users.${username}.extraGroups = ["docker"];
  };
}
