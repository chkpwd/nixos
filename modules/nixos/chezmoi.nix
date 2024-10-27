{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.chezmoi;
in
{
  options.local.chezmoi = {
    enable = mkEnableOption "Enable chezmoi";
  };

  config = mkIf cfg.enable {
    systemd.services."chezmoi-init" = {
      description = "Initialize Chezmoi";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        mkdir -p $HOME/.config/chezmoi
        echo "
        data:
          accessToken: $(cat ${config.sops.secrets.chezmoi_token.path})
        " > $HOME/.config/chezmoi/chezmoi.yml
      '';
      serviceConfig = {
        User = config.crossSystem.username;
        Type = "oneshot";
        WorkingDirectory = "/home/${config.crossSystem.username}";
      };
    };
  };
}
