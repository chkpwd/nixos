{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  # Development Tools
    yq
    jq
    jqp
    istioctl
    fluxcd
    hugo
    etcd
    packer
    govc
    #kairos
    yt-dlp
    #korb
    atuin
    bws
    bitwarden-cli
    pet
    teller
    chezmoi
    stern
    viddy
    k9s
    terraform
    vcluster
    nova
    pluto
    kubectl
    krew
    kubectx
    kubernetes-helm
    unzip
    pwgen
    git
    rsync
    rclone
    pkg-config
    go
    upx
    #alien
  # Network Tools
    sshpass
    nmap
    drill
    traceroute
    dnsutils
    ipcalc
    #genisoimage
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
