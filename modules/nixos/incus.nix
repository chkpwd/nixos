{
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.local.incus;
in {
  options.local.incus = {
    enable = mkEnableOption "Enable Incus on the host";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      incus = {
        enable = true;
        ui.enable = true;
        preseed = {
          config = {
            core.https_address = "172.16.16.150:9999";
            images.auto_update_interval = 6;
          };
          networks = [
            {
              config = {
                "ipv4.address" = "172.16.16.150/24";
                "ipv4.nat" = "true";
              };
              name = "incusbr0";
              type = "bridge";
            }
          ];
          profiles = [
            {
              devices = {
                eth0 = {
                  name = "eth0";
                  network = "incusbr0";
                  type = "nic";
                };
                root = {
                  path = "/";
                  pool = "default";
                  type = "disk";
                };
              };
              name = "default";
            }
          ];
          storage_pools = [
            {
              config = {
                source = "/var/lib/incus/storage-pools/default";
              };
              driver = "dir";
              name = "default";
            }
          ];
        };
      };
    };
    users.users.${username}.extraGroups = ["incus-admin"];
  };
}
