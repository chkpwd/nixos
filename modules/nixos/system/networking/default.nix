{
  lib,
  ...
}:
with lib; {
  networking = {
    hostName = mkDefault "nixos";
    domain = mkDefault "local.chkpwd.com";
    nameservers = mkDefault ["172.16.16.1"];
  };
}
