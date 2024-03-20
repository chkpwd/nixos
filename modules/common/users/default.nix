{
  lib,
  username,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.modules.users.${username};
in {
  imports = [
    ../home-manager {
      inherit inputs;
      username = "chkpwd";
    }
  ];

  options.modules.users.${username} = {
    enable = mkEnableOption "Enable user ${username} configuration";
    enableDevTools =
      mkEnableOption "Enable dev tools"
      // {
        default = false;
      };
  };

  config = mkIf (cfg.enable) (mkMerge [
    (mkIf (pkgs.stdenv.isLinux) (import ./systems/nixos.nix))
    (mkIf (pkgs.stdenv.isDarwin) (import ./systems/darwin.nix))

    {
      users.users.chkpwd = {
        shell = pkgs.zsh;
      };

      modules.users.chkpwd.home-manager.enable = true;

      modules.users.chkpwd.shell.git = {
        enable = true;
        username = "Bryan Jones";
        email = "me@chkpwd.com";
      };
    }

    mkIf cfg.enableDevTools (import ./packages/dev-tools.nix {
      inherit lib;
      inherit pkgs;
    })
  ]);
}
