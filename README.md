<div align="center">

# Nix Configuration

[![built with nix](https://img.shields.io/badge/built_with_nix-blue?style=for-the-badge&logo=nixos&logoColor=white)](https://builtwithnix.org)

</div>

This is a highly opiniated NixOS configuration designed with modularity in mind.

The following tools are used in this stack:

- [deploy-rs]
- [nix-darwin]

## How to Use

#### Update

```console
nix flake update
```

#### Deployment

To apply the NixOS configuration to a node, use the following command:

###### deploy-rs

```console
deploy .#$(hostname)
```

###### Linux
```console
nixos-rebuild switch --flake github:chkpwd/nixos/<branch>#$(hostname -s)
```

###### MacOS
```console
darwin-rebuild switch --flake .#$(hostname -s)
```

###### nixos-anywhere
```nix
nix run github:nix-community/nixos-anywhere -- --flake .#$(hostname) --build-on-remote nixos@<ip-address>
```
