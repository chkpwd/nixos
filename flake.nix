{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nh.url = "github:ToyVo/nh_plus";
    nix-inspect.url = "github:bluskript/nix-inspect";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    krewfile = {
      url = "github:brumhard/krewfile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      overlays = import ./overlays { inherit inputs; };
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});

      nixosConfig =
        {
          system ? "x86_64-linux",
          modules ? [ ],
        }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          inherit system;
          modules = [
            ./modules/nixos
            ./modules/common
            { nixpkgs.overlays = builtins.attrValues overlays; }
          ] ++ modules;
        };

      darwinConfig =
        {
          system ? "aarch64-darwin",
          modules ? [ ],
        }:
        inputs.nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
          };
          inherit system;
          modules = [
            ./modules/darwin
            ./modules/common
            { nixpkgs.overlays = builtins.attrValues overlays; }
          ] ++ modules;
        };
    in
    {
      darwinConfigurations = {
        nix-mb-01 = darwinConfig {
          system = "aarch64-darwin";
          modules = [ ./hosts/nix-mb-01/default.nix ];
        };
      };

      nixosConfigurations = {
        nix-vm-01 = nixosConfig { modules = [ ./hosts/nix-vm-01.nix ]; };
        nix-host-01 = nixosConfig { modules = [ ./hosts/nix-host-01/default.nix ]; };
      };

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = [
            pkgs.nix-inspect
            pkgs.deploy-rs
            pkgs.nvd
            pkgs.nix-output-monitor
            pkgs.nh
          ];
          shellHook = ''
            echo "Nix Development Environment"
          '';
        };
      });

      checks = forAllSystems (pkgs: {
        codeCheck = pkgs.callPackage (
          {
            runCommandNoCCLocal,
            statix,
            deadnix,
            nixfmt-rfc-style,
          }:
          runCommandNoCCLocal "statix-check"
            {
              buildInputs = [
                statix
                deadnix
                nixfmt-rfc-style
              ];
            }
            ''
              touch $out
              statix check ${self}  | tee -a $out
              deadnix check --fail ${self} | tee -a $out
              nixfmt -c ${self} | tee -a $out
            ''
        ) { };
      });
    }
    // import ./deploy.nix { inherit self inputs; };
}
