{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  networking = {
    hostName = mkDefault "nixos";
    search = mkDefault [ "local.chkpwd.com" ];
  };
}
