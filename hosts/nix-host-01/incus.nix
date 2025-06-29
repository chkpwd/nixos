{ config, ... }:
{
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
    preseed = {
      config = {
        "core.https_address" = "[::]:8443";
      };
      networks = [
        {
          name = "incusbr0";
          type = "bridge";
          config = {
            "ipv4.address" = "10.0.10.6/24";
            "ipv4.nat" = true;
            "ipv6.address" = "auto";
          };
        }
      ];
      storage_pools = [
        {
          config.source = "/data";
          driver = "dir";
          name = "default";
        }
      ];
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              type = "nic";
              network = "incusbr0";
            };
            root = {
              path = "/";
              pool = "default";
              size = "20GB";
              type = "disk";
            };
          };
        }
      ];
    };
  };
  users.users.${config.crossSystem.username}.extraGroups = [ "incus-admin" ];
}
