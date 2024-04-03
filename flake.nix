{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {self, ...}@inputs:
  let
    username = "chkpwd";
    sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBK2VnKgOX7i1ISETheqjAO3/xo6D9n7QbWyfDAPsXwa";
    overlays = import ./overlays {inherit inputs;};
    systemConfig = system: modules: overlays:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        overlays = builtins.attrValues overlays;
        modules = [./modules] ++ modules;
      };
    darwinConfig = system: modules: overlays:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        overlays = builtins.attrValues overlays;
        modules = [./modules] ++ modules;
      };
  in
    {
      inherit overlays;

      darwinConfigurations = {
        nix-mb-01 = darwinConfig "x86_64-darwin" [./hosts/nix-mb-01.nix] overlays;
      };

      nixosConfigurations = {
        nix-vm-01 = systemConfig "x86_64-linux" [./hosts/nix-vm-01.nix] overlays;
        nix-wsl-01 = systemConfig "x86_64-linux" [./hosts/nix-wsl-01.nix] overlays;
      };
    }
    // import ./deploy.nix {inherit self inputs username;};
}
