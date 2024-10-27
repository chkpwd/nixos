{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  networking = {
    hostName = mkDefault "nixos";
    nameservers = mkDefault [ "172.16.16.1" ];
    domain = mkDefault "local.chkpwd.com";
  };
}
