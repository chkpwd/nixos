{
  lib,
  config,
  inputs,
  username,
  sshPubKey,
  ...
}:
with lib; let
  cfg = config.local.home-manager;
in {
  imports = [inputs.home-manager.darwinModules.home-manager];

  options.local.home-manager = {
    enable = mkEnableOption "Enable Home Manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        inherit username;
        inherit sshPubKey;
      };

      sharedModules = [inputs.nixcord.homeManagerModules.nixcord];

      users.${username} = {
        home = {
          stateVersion = "24.05";
        };
        programs.home-manager.enable = true;
      };
    };
  };
}
