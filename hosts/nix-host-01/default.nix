{ config, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./incus.nix
  ];

  networking = {
    hostName = "nix-host-01";
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

  networking = {
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = false;
    interfaces.enp0s31f6 = {
      ipv4.addresses = [
        {
          address = "10.0.10.6";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "10.0.10.1";
      interface = "enp0s31f6";
    };
    nftables.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
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

  system.stateVersion = "24.11";
}
