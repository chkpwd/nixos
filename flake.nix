{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    vscode-server,
    ...
  }: inputs let
    username = "chkpwd";
    sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBK2VnKgOX7i1ISETheqjAO3/xo6D9n7QbWyfDAPsXwa";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.default
        vscode-server.nixosModules.default
        nixos-wsl.nixosModules.wsl
        ({pkgs, ...}: {
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

          nix = {
            gc = {
              automatic = true;
              dates = "weekly";
              options = "--delete-older-than 7d";
            };
            settings = {
              experimental-features = ["nix-command" "flakes"];
              auto-optimise-store = true;
              accept-flake-config = true;
              trusted-users = ["root" "@wheel"];
              substituters = [
                "https://nix-community.cachix.org"
                "https://cache.nixos.org/"
              ];
            };
          };

          wsl = {
            enable = true;
            defaultUser = username;
            startMenuLaunchers = true;
            nativeSystemd = true;
            interop.register = true;
          };

          users = {
            mutableUsers = false;
            users.${username} = {
              isNormalUser = true;
              extraGroups = ["wheel"];
              openssh.authorizedKeys.keys = [sshPubKey];
            };
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
        })
      ];
    };
  };
}
