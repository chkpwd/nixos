{
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.local.docker;
in {
  options.local.docker = {
    enable = mkEnableOption "Enable Docker on the host";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
      };
    };

    users.users.${username}.extraGroups = ["docker"];
  };
}
