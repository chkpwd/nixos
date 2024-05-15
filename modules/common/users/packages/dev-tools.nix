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
      ruff
      nodejs_20
      cargo
      clang
      gnumake
      age
      sops
      go
      neovim
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
      yq-go
      jq
      jqp
      # Service
      unstable.fluxcd
      hugo
      etcd
      terraform
      packer
      bws
      act
      lazygit
      # Python
      (python311.withPackages (ps: [
        ps.pip
        ps.ansible-core
        ps.molecule
      ]))
      poetry
      ansible-lint
      # Misc
      tokei
      ffmpeg
      yt-dlp
      mkdocs
    ];
  };
}
