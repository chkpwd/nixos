{
  pkgs,
  config,
  username,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];
  environment = {
    systemPackages = with pkgs; [
      age
      sops
    ];
    etc = {
      "sops/age/nix.txt" = {
        source = /mnt/c/users/chkpwd/nix-agekey.txt;
        user = config.users.users.${username}.name;
        group = config.users.users.${username}.group;
      };
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/default.yml;
    age.keyFile = "/etc/sops/age/nix.txt";
    secrets.chezmoi_token.owner = username;
  };
}
