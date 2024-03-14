{
  pkgs,
  inputs,
  username,
  ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    ../modules/nixos/docker.nix
  ];

  services.vscode-server.enable = true;
  environment = {
    systemPackages = with pkgs; [
      htop
    ];
  };

  networking = {
    domain = "local.chkpwd.com";
    nameservers = ["172.16.16.1"];
    hostName = "test-nixos";
  };

  home-manager = {
    users.${username}.imports = [
      ../modules/home/dev
      ({lib, ...}: {
        # home.file = {
        #   ".vscode-server/server-env-setup" = {
        #     text = ''
        #       # Add default system pkgs
        #       PATH=$PATH:/run/current-system/sw/bin/
        #     '';
        #   };
        # };
        programs.git.enable = true;
      })
    ];
  };
}
