{
  lib,
  config,
  username,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.users.${username};
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
      atuin
      pet
      chezmoi
      # System
      wget
      curl
      htop
      unzip
      age
      sops
      pwgen
      git
      rsync
      rclone
      go
      upx
      # Network
      sshpass
      nmap
      ipcalc
      tree
      drill
      traceroute
      dnsutils
    ];

    users.users.chkpwd.packages = with pkgs; [
      # Parser
      yq
      jq
      jqp
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
      # Kubernetes
      stern
      viddy
      k9s
      vcluster
      nova
      pluto
      kubectl
      krew
      kubectx
      kubernetes-helm
      kustomize
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
    ];
  };
}
