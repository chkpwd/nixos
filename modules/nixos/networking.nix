{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  networking = {
    hostName = mkDefault "nixos";
    nameservers = mkDefault [ "10.0.10.4" ]
    domain = mkDefault "chkpwd.com";
  };
}
