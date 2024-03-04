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
  }: let
    username = "chk";
    sshPubKey = "ssh-ed25519 CHKTHISKEY";
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

          wsl = {
            enable = true;
            wslConf.automount.root = "/mnt";
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
              shell = pkgs.fish;
              openssh.authorizedKeys.keys = [sshPubKey];
            };
          };

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
                };

                programs.home-manager.enable = true;
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
