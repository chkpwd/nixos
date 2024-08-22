# user-module.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  # Import the user data from the user-data.nix file
  userData = import ./user-data.nix;
in {
  options = {
    users = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the user management based on the user data.";
      };
    };
  };

  config = lib.mkIf config.users.enable {
    users.users = [
      name = userData.username;
      value = {
      isNormalUser = true;
      fullName = userData.fullName;
      extraGroups = ["users"];
      shell = "/bin/bash";
      createHome = true;
      password = ""; # You should set a password or manage authentication via other means
      };
    ];
  };
}
