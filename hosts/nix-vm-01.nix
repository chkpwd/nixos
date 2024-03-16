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

  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  fileSystems = {
    "/" = {
      device = "/dev/sda";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/sda";
      fsType = "vfat";
    };
  };

  networking = {
    domain = "local.chkpwd.com";
    nameservers = ["172.16.16.1"];
    hostName = "test-nixos";
  };

  home-manager = {
    users.${username}.imports = [
      ../modules/home/dev
      {
        programs.git.enable = true;
      }
    ];
  };
}
