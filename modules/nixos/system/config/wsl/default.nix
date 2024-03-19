{
  lib,
  config,
  inputs,
  username,
  ...
}:
with lib; let
  cfg = config.modules.wsl;
in {
  options.modules.wsl = {
    enable = mkEnableOption "Enable WSL on the host";
  };

  imports = [inputs.nixos-wsl.nixosModules.wsl];

  config = mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = username;
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
