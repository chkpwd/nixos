{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.packages;
in
{
  options.local.packages = {
    enableDevTools = mkEnableOption "Enable dev tools";
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
      nixfmt-rfc-style
      fzf
      tmux
      ruff
      nodejs_20
      cargo
      rustc
      clang
      gnumake
      sshpass
      nmap
      ipcalc
      mtr
    ];

    users.users.${config.crossSystem.username}.packages = with pkgs; [
      unstable.terraform
      packer
      pet
      go
      yq-go
      sops
      age
      chezmoi
      jq
      neovim
      bws
      # bitwarden-cli
      crane
      complete-alias
      gh
      act
      (python312.withPackages (ps: [
        ps.pip
        ps.ansible-core
      ]))
      ansible-lint
      pre-commit
      poetry
      android-tools
      imagemagick
      yt-dlp
      mods
      awscli2
      yamlfmt
      yamllint
      tflint
      go-task
      minio-client
      restic
      asciinema
      hwatch
    ];
  };
}
