{
  pkgs,
  inputs,
  config,
  username,
  ...
}: {
  imports = [inputs.vscode-server.nixosModules.default];

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

  networking = {
    hostName = "nix-wsl-01";
  };

  services.vscode-server.enable = true;
  environment = {
    systemPackages = with pkgs; [deploy-rs];
  };

  home-manager = {
    users.${username}.imports = [
      ../modules/common/home-manager/development
      ({ lib, ...}: {
        home.file = {
          ".vscode-server/server-env-setup" = {
            text = ''
              # Add default system pkgs
              PATH=$PATH:/run/current-system/sw/bin/
            '';
          };
        };
        programs.git.enable = true;
      })
    ];
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
