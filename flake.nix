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
    #nixcord.url = "github:kaylorben/nixcord";
    nh-darwin.url = "github:ToyVo/nh-darwin";
  };

  outputs = {self, ...} @ inputs: let
    overlays = import ./overlays {inherit inputs;};

    nixosConfig = {
      system ? "x86_64-linux",
      modules ? [],
    }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        inherit system;
        modules =
          [
            ./modules/nixos
            ./modules/common
            {nixpkgs.overlays = builtins.attrValues overlays;}
          ]
          ++ modules;
      };

    darwinConfig = {
      system ? "aarch64-darwin",
      modules ? [],
    }:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs;};
        inherit system;
        modules =
          [
            ./modules/darwin
            ./modules/common
            {nixpkgs.overlays = builtins.attrValues overlays;}
          ]
          ++ modules;
      };
  in
    {
      darwinConfigurations = {
        nix-mb-01 = darwinConfig {
          system = "aarch64-darwin";
          modules = [./hosts/nix-mb-01/default.nix];
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
    // import ./deploy.nix {inherit self inputs;};
}
