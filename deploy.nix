{
  self,
  inputs,
  ...
}: let
  deployConfig = name: system: cfg: {
    hostname = name;
    profiles.system =
      {
        user = "root";
        sshUser = ""; #lib.strings.splitString "\n" (builtins.readFile ../../homes/bjw-s/config/ssh/ssh.pub);
        path = inputs.deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${name};
        magicRollback = true;
        sshOpts = [];
        remoteBuild = false;
      }
      // cfg; # Update operator to merge two attrSets; right wins
  };
in {
  deploy.nodes = {
    nix-vm-01 = deployConfig "nix-vm-01" "x86_64-linux" {};
    nix-wsl-01 = deployConfig "nix-wsl-01" "x86_64-linux" {};
    nix-host-01 = deployConfig "nix-host-01" "x86_64-linux" {
      remoteBuild = true;
    };
  };
}
