{
  modulesPath,
  config,
  lib,
  pkgs,
  username,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../modules/nixos/disk-config.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  networking = {
    hostName = "nix-vm-01";
  };

  # Configure user
  local.users.${username} = {
    enable = true;
    enableDevTools = false;
    home-manager = {
      enable = false;
    };
  };

  system.stateVersion = "23.11";
}
