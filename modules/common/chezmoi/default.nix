{
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.modules.chezmoi;
in {
  options.modules.chezmoi = {
    enable = mkEnableOption "Enable chezmoi";
  };

  config = mkIf cfg.enable {
    systemd.services."chezmoi-init" = {
      description = "Initialize Chezmoi";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      script = ''
        mkdir -p $HOME/.config/chezmoi
        echo "
        data:
          accessToken: $(cat ${config.sops.secrets.chezmoi_token.path})
        " > $HOME/.config/chezmoi/chezmoi.yml
      '';
      serviceConfig = {
        User = username;
        Type = "oneshot";
        WorkingDirectory = "/home/${username}";
      };
    };
  };
}
