{
  lib,
  config,
  inputs,
  username,
  sshPubKey,
  ...
}:
with lib; let
  cfg = config.modules.users.${username}.home-manager;
in {
  imports = [inputs.home-manager.nixosModules.default];

  options.modules.users.${username}.home-manager = {
    enable = mkEnableOption "Enable Home Manager";
    # enableDevTools = mkEnableOption "Enable Dev Tools";
    # enableDevShell = mkEnableOption "Enable Dev Shell";
  };

  config = mkMerge [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = {
          inherit inputs;
          inherit username;
          inherit sshPubKey;
        };
      };
    }
    (mkIf (cfg.enable) {
      home-manager.users.${username} = {
        home = {
          stateVersion = "23.11";
        };

        programs = {
          home-manager.enable = true;
        };
      };
    })
  ];
}
