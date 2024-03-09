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
    ../modules/nixos/sops.nix
  ];

  custom.sops = {
    enable = true;
    file = {
      source = ../secrets/default.yml;
    };
    age = {
      source = "/mnt/c/users/chkpwd/nix-agekey.txt";
      destination = "/etc/sops/age/nix.txt";
    };
  };

  services.vscode-server.enable = true;
  environment = {
    systemPackages = with pkgs; [
      htop
      unzip
      drill
      traceroute
      dnsutils
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
