{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = {self, ...} @ inputs: let
    username = "chkpwd";
    sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBK2VnKgOX7i1ISETheqjAO3/xo6D9n7QbWyfDAPsXwa";
    systemConfig = system: modules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs username sshPubKey;};
        inherit system;
        modules =
          [
            ./modules/nixos/system.nix
            ./modules/home
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = {
      wsl = systemConfig "x86_64-linux" [./hosts/wsl.nix];
      test = systemConfig "x86_64-linux" [./hosts/test.nix];
    };
  };
}
