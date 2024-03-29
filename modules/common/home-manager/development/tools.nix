{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
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
  # Shell
    atuin
    pet
    teller
    chezmoi
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
  # System
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
  # Python
    (python311.withPackages (ps: [
      ps.ansible-core
      ps.molecule
    ]))
    ansible-lint
  # Misc
    ffmpeg
    yt-dlp
  ];
}
