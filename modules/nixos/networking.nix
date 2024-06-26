{lib, ...}:
with lib; {
  networking = {
    hostName = mkDefault "nixos";
    nameservers = mkDefault ["172.16.16.1"];
    domain = mkDefault "local.chkpwd.com";
  };
}
