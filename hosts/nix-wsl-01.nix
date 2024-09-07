{config, ...}: {
  networking = {
    hostName = "nix-wsl-01";
  };

  environment.sessionVariables = {
    FLAKE = "/home/${config.crossSystem.username}/code/nixos";
  };

  # # Enable Dynamic Linker
  # programs.nix-ld.enable = true;

  mainUser.enable = true;

  local = {
    vscode-server.enable = true;
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

    chezmoi.enable = true;
  };
}
