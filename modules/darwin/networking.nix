{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  networking = {
    hostName = mkDefault "nixos";
    search = mkDefault [ "chkpwd.com" ];
  };
}
