{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    systemConfig = system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        modules = [./modules] ++ modules;
      };
  in
  {
    nixosConfigurations = {
      nix-vm-01 = systemConfig "x86_64-linux" [./hosts/nix-vm-01.nix];
      nix-wsl-01 = systemConfig "x86_64-linux" [./hosts/nix-wsl-01.nix];
      nix-mb-01 = systemConfig "aarch64-linux" [./hosts/nix-mb-01.nix];
    };
  } // import ./deploy.nix { inherit self inputs username; };
}
