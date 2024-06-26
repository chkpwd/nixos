{ pkgs, ... }:
{
 config = {
   services.nix-daemon.enable = true;
   nix = {
     extraOptions = ''
       experimental-features = nix-command flakes
     '';
   };
 };
}
