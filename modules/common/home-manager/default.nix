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

      users.${username} = {
        home = {
          stateVersion = "23.11";
          file = mkIf (config.modules.wsl.enable == true)  {
            ".vscode-server/server-env-setup" = {
              text = ''
                # Add default system pkgs
                PATH=$PATH:/run/current-system/sw/bin/
              '';
            };
          };
        };

        programs = {
          home-manager.enable = true;
        };
      };
    };
  };
}
