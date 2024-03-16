{
  self,
  inputs,
  username,
  ...
}: let
  deployConfig = name: host: system: cfg: {
    hostname = host;
    profiles.system = {
      user = "root";
      sshUser = username;
      path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
      magicRollback = cfg.magicRollback or true;
      sshOpts = cfg.sshOpts or [];
    };
  };
in {
  deploy.nodes = {
    nix-vm-01 = deployConfig "nix-vm-01" "172.16.20.12" "x86_64-linux" {};
    nix-wsl-01 = deployConfig "nix-wsl-01" "nixos" "x86_64-linux" {};
  };
  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
}
