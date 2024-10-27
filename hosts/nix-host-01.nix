{ config, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ../modules/nixos/disk-config.nix
  ];

  networking = {
    hostName = "nix-host-01";
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  disko.devices = {
    disk.disk1 = {
      device = "/dev/sda";
    };
  };

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  networking = {
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp2s0.useDHCP = false;
    nftables.enable = true;
    firewall = {
      allowedTCPPorts = [
        8443
        53
        67
        22
      ];
      allowedUDPPorts = [
        53
        67
      ];
    };
  };

  services = {
    openssh.enable = true;
    qemuGuest.enable = true;
  };

  mainUser.enable = true;

  local.incus = {
    enable = true;
  };

  system.stateVersion = "24.05";
}
