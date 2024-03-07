{
  pkgs,
  inputs,
  config,
  lib,
  username,
  ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
    inputs.sops-nix.nixosModules.sops
  ];

  system.stateVersion = "23.11";
  services.vscode-server.enable = true;
  environment = {
    systemPackages = with pkgs; [
      vim
      htop
      wget
    ];
    pathsToLink = ["/share/zsh"];
    shells = [pkgs.zsh];
  };

  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = true;
    nativeSystemd = true;
    interop.register = true;
  };

  # Allow Proprietary software
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
    secrets.chezmoi_token.owner = username;
  };

  home-manager = {
    users.${username}.imports = [
      ../modules/home/dev
      {
        home.file = {
          ".vscode-server/.env" = {
          text = ''
            # Add system pkgs
            PATH=$PATH:/run/current-system/sw/bin/
          '';
          };
        };

        home.activation = {
          pre-chezmoi = ''
              # Create Chezmoi configuration file with access token
              $DRY_RUN_CMD mkdir -p $HOME/.config/chezmoi
              $DRY_RUN_CMD \
              echo "data:
                accessToken: $(cat ${config.sops.secrets.chezmoi_token.path})" > "$HOME/.config/chezmoi/chezmoi.yml"
          '';
          # post-chezmoi = lib.hm.dag.entryAfter ["writeBoundary"] ''
          post-chezmoi = ''
            $DRY_RUN_CMD ${pkgs.chezmoi}/bin/chezmoi init --apply ${username}
          '';
        };

        programs.zsh.enable = true;
        programs.git.enable = true;
      }
    ];
  };
}
