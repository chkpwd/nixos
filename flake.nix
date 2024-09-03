{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-inspect.url = "github:bluskript/nix-inspect";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixcord.url = "github:kaylorben/nixcord";
  };

  outputs = {self, ...} @ inputs: let
    username = "chkpwd";
    sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBK2VnKgOX7i1ISETheqjAO3/xo6D9n7QbWyfDAPsXwa";
    overlays = import ./overlays {inherit inputs;};

    mkHomeModules = addHM: moduleType:
      if addHM
      then [
        inputs.home-manager.${moduleType}.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs username sshPubKey;};
            users.${username} = {
              home = {
                stateVersion = "24.05";
              };
              programs.home-manager.enable = true;
            };
          };
        }
      ]
      else [];

    nixosConfig = {
      system ? "x86_64-linux",
      modules ? [],
      addHM ? true,
    }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        modules =
          [
            ./modules/nixos
            ./modules/common
            {nixpkgs.overlays = builtins.attrValues overlays;}
          ]
          ++ modules
          ++ (mkHomeModules addHM "nixosModules");
      };

    darwinConfig = {
      system ? "aarch64-darwin",
      modules ? [],
      addHM ? true,
    }:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        modules =
          [
            ./modules/darwin
            ./modules/common
            {nixpkgs.overlays = builtins.attrValues overlays;}
          ]
          ++ modules
          ++ (mkHomeModules addHM "darwinModules");
      };
  in
    {
      darwinConfigurations = {
        nix-mb-01 = darwinConfig {
          system = "x86_64-darwin";
          modules = [./hosts/nix-mb-01.nix];
        };
      };

      nixosConfigurations = {
        nix-vm-01 = nixosConfig {
          modules = [./hosts/nix-vm-01.nix];
        };
        nix-host-01 = nixosConfig {
          modules = [./hosts/nix-host-01.nix];
        };
      };
    }
    // import ./deploy.nix {inherit self inputs username;};
}
