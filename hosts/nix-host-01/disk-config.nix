{ inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.default ];

  disko.devices = {
    disk.disk = {
      device = "/dev/disk/by-id/ata-WDC_WDBNCE5000PNC_20290C801152";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "500M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "45G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
          data = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/data";
            };
          };
        };
      };
    };
  };
}
