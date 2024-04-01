{
  pkgs,
  username,
  ...
}: {
  local.vscode-server.enable = true;

  networking = {
    hostName = "nix-vm-01";
  };

  environment = {
    systemPackages = with pkgs; [deploy-rs];
  };

  # Configure user
  local.users.${username} = {
    enable = true;
    enableDevTools = true;
    home-manager = {
      enable = true;
    };
  };

  local.wsl.enable = true;

  local.docker.enable = true;

  local.sops = {
    enable = true;
    file = {
      source = ../secrets/default.yml;
    };
    age = {
      source = "/mnt/c/users/chkpwd/nix-agekey.txt";
      destination = "/etc/sops/age/nix.txt";
    };
  };

  local.chezmoi.enable = true;

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
}
