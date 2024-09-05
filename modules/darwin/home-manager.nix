{
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.home-manager;
in {
  imports = [inputs.home-manager.darwinModules.default];

  options.local.home-manager = {
    enable = mkEnableOption "Enable Home Manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        inherit (config.crossSystem) username sshPubKey;
      };

      users.${config.crossSystem.username} = {
        home = {
          stateVersion = "23.11";
        };
      };
    };
  };
}
