{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.packages;
  nix-inspect = inputs.nix-inspect.packages.${pkgs.system}.default;
in {
  options.local.packages = {
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
      bat
      fd
      file
      ripgrep
      fzf
      tmux
      ruff
      nodejs_20
      cargo
      rustc
      clang
      gnumake
      unstable.neovim
      sshpass
      nmap
      ipcalc
      #traceroute
      nix-inspect
      deploy-rs
      nh
      nvd
      nix-output-monitor
    ];

    users.users.${config.crossSystem.username}.packages = with pkgs; [
      pet
      go
      yq-go
      sops
      age
      chezmoi
      jq
      jqp
      fluxcd
      terraform
      packer
      bws
      bitwarden-cli
      just
      crane
      complete-alias
      tldr
      gh
      (python311.withPackages (ps: [
        ps.pip
        ps.ansible-core
      ]))
      pre-commit
      poetry
      ansible-lint
      android-tools
      imagemagick
      ffmpeg
      yt-dlp
    ];
  };
}
