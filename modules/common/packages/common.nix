{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
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
    ];

    users.users.${config.crossSystem.username}.packages = with pkgs; [
      todo-txt-cli
    ];
  };
}
