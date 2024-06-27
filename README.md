
<div align="center">

# Nix Configuration
[![built with nix](https://img.shields.io/badge/built_with_nix-blue?style=for-the-badge&logo=nixos&logoColor=white)](https://builtwithnix.org)

</div>

This is a highly opiniated NixOS configuration designed with modularity in mind.

The following tools are used in this stack:
- [deploy-rs]
- [nix-darwin]

## How to Use

### Deployment

#### NixOS

To apply the NixOS configuration to a node, use the following command:
##### Using Deploy
```console
deploy .#<name-of-host>
```
##### Using NixOS
```console
sudo nixos-rebuild switch --flake github:chkpwd/nixos/<branch>#<name-of-host>
```

### TODO
- [x] MacOS Setup
- [x] Setup Overlays
