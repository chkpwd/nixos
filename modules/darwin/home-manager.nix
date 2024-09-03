{
  lib,
  config,
  inputs,
  username,
  sshPubKey,
  ...
}:
with lib; let
  cfg = config.home-manager;
in {
  options.home-manager.enable = mkEnableOption "Enable Home Manager";

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
        inherit username;
        inherit sshPubKey;
      };

      users.${username} = {
        home = {
          stateVersion = "24.05";
        };
        programs.home-manager.enable = true;
      };
    };
  };
}
