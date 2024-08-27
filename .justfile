timeout := "300s"

# List tasks
default:
  just --list

# NixOS Remote Rebuild Switch using nix-shell
rebuild
remote-rebuild:
  nix-shell -p nixos-rebuild --run 'nixos-rebuild build --flake .#{{HOST}} --fast --use-remote-sudo --build-host "{{USER}}@{{HOST}}.local.chkpwd.com" --target-host "{{USER}}@{{HOST}}.local.chkpwd.com"'
