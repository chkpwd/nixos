{
  self,
  inputs,
  ...
}: let
  deployConfig = name: host: system: cfg: {
    hostname = host;
    profiles.system = {
      user = "chkpwd";
      sshUser = "chkpwd";
      #path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
      magicRollback = cfg.magicRollback or true;
      sshOpts = cfg.sshOpts or [];
    };
  };
in {
  deploy.nodes = {
    nix-ws-01 = deployConfig "nix-ws-01" "nixos" "x86_64-linux" {};
  };
  checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
}
