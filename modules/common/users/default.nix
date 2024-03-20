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
    (import ../home-manager {username = "chkpwd";})
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
    (mkIf (pkgs.stdenv.isLinux) (import ./systems/nixos.nix {inherit config;}))
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
        # signing = {
        #   signByDefault = true;
        #   key = "0x80FF2B2CE4316DEE";
        # };
        # aliases = {
        #   co = "checkout";
        #   logo = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ (%cn)\" --decorate";
        # };
        # config = {
        #   core = {
        #     autocrlf = "input";
        #   };
        #   init = {
        #     defaultBranch = "main";
        #   };
        #   pull = {
        #     rebase = true;
        #   };
        #   rebase = {
        #     autoStash = true;
        #   };
        # };
        # ignores = [
        #   # Mac OS X hidden files
        #   ".DS_Store"
        #   # Windows files
        #   "Thumbs.db"
        #   # asdf
        #   ".tool-versions"
        #   # mise
        #   ".mise.toml"
        #   # Sops
        #   ".decrypted~*"
        #   "*.decrypted.*"
        #   # Python virtualenvs
        #   ".venv"
        # ];
      };
    }

    (mkIf (cfg.enableDevTools) (import ./packages/dev-tools.nix {
      inherit lib;
      inherit pkgs;
    }))
  ]);
}
