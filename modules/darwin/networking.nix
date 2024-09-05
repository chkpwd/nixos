{lib, ...}: let
  inherit (lib) mkDefault;
in {
  networking = {
    hostName = mkDefault "nixos";
    search = mkDefault ["local.chkpwd.com"];
    dns = mkDefault ["172.16.16.1"];
  };
}
