{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
    ../modules/home/dev-tools.nix
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
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username}.imports = [
      {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion = "23.11";
          packages = with pkgs; [curl wget];
          file = {
            vscode = {
              target = ".vscode-server/.env";
              text = ''
                # Add system pkgs
                PATH=$PATH:/run/current-system/sw/bin/
              '';
            };
          };
        };

        programs.home-manager.enable = true;
        programs.zsh.enable = true;
        programs.git.enable = true;
        services.ssh-agent.enable = true;
      }
    ];
  };
}
