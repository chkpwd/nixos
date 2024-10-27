{ lib, ... }:
{
  options.crossSystem = lib.mkOption {
    type = lib.types.attrs;
    default = {
      username = "chkpwd";
      sshPubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBK2VnKgOX7i1ISETheqjAO3/xo6D9n7QbWyfDAPsXwa common";
    };
  };
}
