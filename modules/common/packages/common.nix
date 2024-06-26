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
  options.local.users.${username} = {
    enableCommonTools =
      mkEnableOption "Enable common tools";
  };

  config = mkIf cfg.enableCommonTools {
    environment.systemPackages = with pkgs; [
      # Shell
      tree
      # Utils
      wget
      curl
      htop
      unzip
      git
      # Network
      drill
      dnsutils
    ];

    users.users.${username}.packages = with pkgs; [
      todo-txt-cli
    ];
  };
}
