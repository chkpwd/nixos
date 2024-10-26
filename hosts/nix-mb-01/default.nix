{
  pkgs,
  inputs,
  config,
  ...
}: let
  homeDirectory = "/Users/${config.crossSystem.username}";
in {
  imports = [./macos-defaults.nix ./scripts.nix ./homebrew.nix];

  networking = {
    hostName = "nix-mb-01";
    knownNetworkServices = ["Wi-Fi"];
  };

  environment.variables = {
    FLAKE = "${homeDirectory}/code/nixos";
  };

  system = {
    activationScripts.postActivation.text = ''
      sudo chsh -s /run/current-system/sw/bin/zsh chkpwd
    '';
  };

  programs.zsh.enable = true;

  users.users.${config.crossSystem.username} = {
    name = "${config.crossSystem.username}";
    home = homeDirectory;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [config.crossSystem.sshPubKey];
  };

  local = {
    packages = {
      enableCommonTools = true;
      enableDevTools = true;
      enableKubernetesTools = true;
    };
    home-manager = {
      enable = true;
      userOptions = {
        users.${config.crossSystem.username} = {
          imports = [
            inputs.krewfile.homeManagerModules.krewfile
          ];
          programs = {
            krewfile = {
              enable = true;
              krewPackage = pkgs.krew;
              krewRoot = "${homeDirectory}/.krew/bin";
              plugins = [
                "explore"
                "modify-secret"
                "neat"
                "oidc-login"
                "pv-migrate"
                "stern"
                "ctx"
                "ns"
              ];
            };
          };
        };
      };
    };
  };
}
