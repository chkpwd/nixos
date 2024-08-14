{
  lib,
  config,
  username,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.packages;
in {
  options.local.packages = {
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
      terraform
    ];

    users.users.${username}.packages = with pkgs; [
      todo-txt-cli
    ];
  };
}
