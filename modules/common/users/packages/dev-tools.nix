{
  lib,
  config,
  username,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.local.users.${username};
  nix-inspect = inputs.nix-inspect.packages.${pkgs.system}.default;
in {
  options.local.users.${username} = {
    enableDevTools =
      mkEnableOption "Enable dev tools";
  };

  config = mkIf cfg.enableDevTools {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      # Shell
      zsh
      fd
      file
      ripgrep
      fzf
      unstable.atuin
      pet
      chezmoi
      tmux
      # System
      age
      sops
      pwgen
      rsync
      rclone
      go
      upx
      # Network
      sshpass
      nmap
      ipcalc
      traceroute
      # NixOS
      nix-inspect
      deploy-rs
      unstable.nh
      nix-output-monitor
    ];

    users.users.${username}.packages = with pkgs; [
      # Parser
      yq
      jq
      jqp
      unstable.jnv
      # Service
      istioctl
      fluxcd
      hugo
      etcd
      terraform
      packer
      govc
      bws
      bitwarden-cli
      flyctl
      teller
      # Python
      (python311.withPackages (ps: [
        ps.pip
        ps.ansible-core
        ps.molecule
      ]))
      poetry
      ansible-lint
      # Misc
      ffmpeg
      yt-dlp
      mkdocs
    ];
  };
}
