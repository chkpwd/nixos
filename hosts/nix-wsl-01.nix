{
  pkgs,
  config,
  username,
  ...
}: {
  modules.vscode-server.enable = true;

  networking = {
    hostName = "nix-wsl-01";
  };

  environment = {
    systemPackages = with pkgs; [deploy-rs];
  };

  # Configure user
  modules.users.${username} = {
    enable = true;
    enableDevTools = true;
    home-manager = {
      enable = true;
    };
  };

  modules = {
    wsl.enable = true;
    docker.enable = true;
    sops = {
      enable = true;
      file = {
        source = ../secrets/default.yml;
      };
      age = {
        source = "/mnt/c/users/chkpwd/nix-agekey.txt";
        destination = "/etc/sops/age/nix.txt";
      };
    };
  };

  systemd.services."chezmoi-init" = {
    description = "Initialize Chezmoi";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    script = ''
      mkdir -p $HOME/.config/chezmoi
      echo "
      data:
        accessToken: $(cat ${config.sops.secrets.chezmoi_token.path})
      " > $HOME/.config/chezmoi/chezmoi.yml
    '';
    serviceConfig = {
      User = username;
      Type = "oneshot";
      WorkingDirectory = "/home/${username}";
    };
  };
}