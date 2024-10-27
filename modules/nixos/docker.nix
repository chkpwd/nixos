{
  lib,
  config,
  username,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.docker;
in
{
  options.local.docker = {
    enable = mkEnableOption "Enable Docker on the host";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
      };
    };

    users.users.${config.crossSystem.username}.extraGroups = [ "docker" ];
  };
}
