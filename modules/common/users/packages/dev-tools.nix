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
      unstable.atuin
      pet
      chezmoi
      tmux
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
      # NixOS
      nix-inspect
      deploy-rs
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
      # Kubernetes
      minikube
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
      mkdocs
    ];
  };
}
