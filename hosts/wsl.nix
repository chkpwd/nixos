{
  pkgs,
  inputs,
  config,
  username,
  ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.default
    inputs.nixos-wsl.nixosModules.wsl
    inputs.sops-nix.nixosModules.sops
  ];

  services.vscode-server.enable = true;
  environment = {
    systemPackages = with pkgs; [
      htop
    ];
  };

  wsl = {
    enable = true;
    defaultUser = username;
    startMenuLaunchers = true;
    nativeSystemd = true;
    interop = {
      register = true;
      includePath = true;
    };
    wslConf.interop = {
      enabled = true;
      appendWindowsPath = true;
    };
  };

  sops = {
    defaultSopsFile = ../secrets/default.yml;
    age.keyFile = "/etc/sops/age/nix.txt";
    secrets.chezmoi_token.owner = username;
  };

  home-manager = {
    users.${username}.imports = [
      ../modules/home/dev
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
