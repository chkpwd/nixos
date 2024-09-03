{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
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

    systemConfig = system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        modules =
          [
            ./modules/nixos
            ./modules/common
            {nixpkgs.overlays = builtins.attrValues overlays;}
          ]
          ++ modules;
      };

    darwinConfig = system: modules: addHM: let
      hmModule =
        if addHM
        then [inputs.home-manager.darwinModules.home-manager]
        else [];
    in
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
          ++ hmModule;
      };
  in
    {
      darwinConfigurations = {
        nix-mb-01 = darwinConfig "aarch64-darwin" [./hosts/nix-mb-01.nix] true;
      };

      nixosConfigurations = {
        nix-vm-01 = systemConfig "x86_64-linux" [./hosts/nix-vm-01.nix];
        nix-wsl-01 = systemConfig "x86_64-linux" [./hosts/nix-wsl-01.nix];
        nix-host-01 = systemConfig "x86_64-linux" [./hosts/nix-host-01.nix];
      };
    }
    // import ./deploy.nix {inherit self inputs username;};
}
