{
  lib,
  config,
  inputs,
  username,
  ...
}:
with lib; let
  cfg = config.modules.${username}.home-manager;
in {
  imports = [inputs.home-manager.nixosModules.default];

  options.modules.users.${username}.home-manager = {
    enable = mkEnableOption "Enable Home Manager";
    isWSL = mkEnableOption "Enable WSL specific settings";
  };

  config = mkMerge [
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
      };
    }

    (mkIf (cfg.enable) {
      home-manager.users.${username} = {
        home = {
          stateVersion = "23.11";
        };

        programs = {
          home-manager.enable = true;
          git.enable = true;
        };
      };
    })

    (mkIf (cfg.isWSL) {
      home-manager.users.${username}.imports = [
        ({lib, ...}: {
          home.file = {
            ".vscode-server/server-env-setup" = {
              text = ''
                # Add default system pkgs
                PATH=$PATH:/run/current-system/sw/bin/
              '';
            };
          };
        })
      ];
    })
  ];
}
