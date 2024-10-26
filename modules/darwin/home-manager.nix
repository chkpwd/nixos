{
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.local.home-manager;
in {
  imports = [inputs.home-manager.darwinModules.default];

  options.local.home-manager = {
    enable = mkEnableOption "Enable Home Manager";

    userOptions = mkOption {
      type = lib.types.attrs; # checks if its a attrset
      default = {};
      description = "User options for Home Manager";
    };
  };

  config = mkIf cfg.enable {
    home-manager =
      lib.attrsets.recursiveUpdate {
        # recursively merge options from cfg
        useGlobalPkgs = true;
        useUserPackages = false;
        extraSpecialArgs = {inherit inputs;};
        users.${config.crossSystem.username} = {
          home = {
            stateVersion = "23.11";
            homeDirectory = "/Users/${config.crossSystem.username}";
          };
          programs.home-manager.enable = true;
        };
      }
      cfg.userOptions;
  };
}
