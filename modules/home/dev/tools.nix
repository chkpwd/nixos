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
    yt-dlp
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
    unzip
    pwgen
    git
    rsync
    rclone
    pkg-config
    go
    upx
  # Network Tools
    sshpass
    nmap
    drill
    traceroute
    dnsutils
    ipcalc
    tree
    age
    hugo
    ffmpeg
  # Ansible
    (python311.withPackages (ps: [
      ps.ansible-core
      ps.molecule
    ]))
    ansible-lint
  ];
}
