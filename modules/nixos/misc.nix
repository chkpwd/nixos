{ lib, pkgs, ... }:
{
  system = {
    # Diff system configuration
    activationScripts.report-changes = ''
      PATH=$PATH:${
        lib.makeBinPath [
          pkgs.nvd
          pkgs.nix
        ]
      }
      nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
    '';
  };
}
