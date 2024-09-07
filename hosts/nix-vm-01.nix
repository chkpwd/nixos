{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../modules/nixos/disk-config.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking = {
    hostName = "nix-vm-01";
  };

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  mainUser.enable = true;

  system.stateVersion = "23.11";
}
