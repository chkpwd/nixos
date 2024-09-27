{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [./macos-defaults.nix ./scripts.nix ./homebrew.nix];

  networking = {
    hostName = "nix-mb-01";
    knownNetworkServices = ["Wi-Fi"];
  };

  environment.variables = {
    FLAKE = "/Users/${config.crossSystem.username}/code/nixos";
    KREW_ROOT = "/Users/${config.crossSystem.username}/.krew/bin";
  };

  system = {
    activationScripts.postActivation.text = ''
      sudo chsh -s /run/current-system/sw/bin/zsh chkpwd
    '';
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  programs.zsh.enable = true;

  users.users.${config.crossSystem.username} = {
    name = "${config.crossSystem.username}";
    home = "/Users/${config.crossSystem.username}";
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
          imports = [inputs.nixcord.homeManagerModules.nixcord inputs.krewfile.homeManagerModules.krewfile];
          programs = {
            krewfile = {
              enable = true;
              krewPackage = pkgs.krew;
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

            # nixcord = {
            #   enable = true;
            #   config = {
            #     themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-macchiato.theme.css"];
            #     plugins = {
            #       fakeNitro.enable = true;
            #       pinDMs.enable = true;
            #     };
            #   };
            #
            #   discord.enable = false;
            #   vencord.enable = false;
            #
            #   vesktop.enable = true;
            #   vesktopPackage = pkgs.unstable.vesktop;
            # };
          };
        };
      };
    };
  };
}
