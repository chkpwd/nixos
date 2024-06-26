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
      bat
      zsh
      fd
      file
      ripgrep
      fzf
      pet
      chezmoi
      tmux
      complete-alias
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
<<<<<<< HEAD:modules/common/packages/dev.nix
      #nh
=======
      nh
>>>>>>> main:modules/common/users/packages/dev-tools.nix
      nix-output-monitor
    ];

    users.users.${username}.packages = with pkgs; [
      # Parser
      yq-go
      jq
      jqp
      # Service
      fluxcd
      hugo
      etcd
      terraform
      packer
      bws
      act
      lazygit
      just
      navi
      crane
      gh
      # Python
      (python311.withPackages (ps: [
        ps.pip
        ps.ansible-core
        ps.molecule
      ]))
      pre-commit
      poetry
      ansible-lint
      # Misc
      tokei
      ffmpeg
      yt-dlp
      mkdocs
      android-tools
    ];
  };
}
