{
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.wsl;
in
{
  options.local.wsl = {
    enable = mkEnableOption "Enable WSL on the host";
  };

  imports = [ inputs.nixos-wsl.nixosModules.wsl ];

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = config.crossSystem.username;
      startMenuLaunchers = true;
      nativeSystemd = true;
      interop = {
        register = true;
        includePath = true;
      };
      wslConf = {
        network = {
          generateResolvConf = false;
        };
        interop = {
          enabled = true;
          appendWindowsPath = true;
        };
      };
    };
  };
}
