{
  lib,
  ...
}:
with lib; {
  networking.hostName = mkDefault "nixos";
}
