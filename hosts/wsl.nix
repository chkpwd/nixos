{
  pkgs,
  inputs,
  config,
  username,
  ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
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

  home-manager = {
    users.${username}.imports = [
      ../modules/home/dev
      {
        home.file.vscode = {
          target = ".vscode-server/.env";
          text = ''
            # Add system pkgs
            PATH=$PATH:/run/current-system/sw/bin/
          '';
        };

        home.file.chezmoi = {
          target = ".vscode-server/.env";
          text = ''
            # Add Chezmoi Access Token
            data:
              accessToken: ${config.sops.secrets.chezmoi_token.path}
          '';
        };

        programs.zsh.enable = true;
        programs.git.enable = true;
      }
    ];
  };
}
