{
  lib,
  config,
  username,
  pkgs,
  inputs,
  ...
}:
with lib; let
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
      # Shell
      bat
      fd
      file
      ripgrep
      fzf
      pet
      chezmoi
      tmux
      iterm2
      complete-alias
      # System
      ruff
      nodejs_20
      cargo
      rustc
      clang
      gnumake
      age
      sops
      go
      unstable.neovim
      # Network
      sshpass
      nmap
      ipcalc
      #traceroute
      # NixOS
      nix-inspect
      deploy-rs
      nh
      nix-output-monitor
    ];

    users.users.${username}.packages = with pkgs; [
      # Parser
      yq-go
      jq
      jqp
      # Service
      fluxcd
      terraform
      packer
      bws
      just
      crane
      gh
      # Python
      (python311.withPackages (ps: [
        ps.pip
        ps.ansible-core
      ]))
      pre-commit
      poetry
      ansible-lint
      # Misc
      mkdocs
      android-tools
    ];
  };
}
