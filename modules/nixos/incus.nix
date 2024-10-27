{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.incus;
in
{
  options.local.incus = {
    enable = mkEnableOption "Enable Incus on the host";
  };

  config = mkIf cfg.enable {
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
              "ipv4.address" = "172.16.16.150/24";
              "ipv4.nat" = true;
              "ipv6.address" = "auto";
            };
          }
        ];
        # storage_pools = [
        #   {
        #     config.source = "/vm-data";
        #     driver = "dir";
        #     name = "default";
        #   }
        # ];
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
          {
            name = "external";
            devices = {
              eth1 = {
                name = "eth1";
                type = "nic";
                nictype = "bridged";
                parent = "br0";
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
  };
}
