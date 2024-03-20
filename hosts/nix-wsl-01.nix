{
  pkgs,
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

  modules.wsl.enable = true;

  modules.docker.enable = true;

  modules.sops = {
    enable = true;
    file = {
      source = ../secrets/default.yml;
    };
    age = {
      source = "/mnt/c/users/chkpwd/nix-agekey.txt";
      destination = "/etc/sops/age/nix.txt";
    };
  };

  modules.chezmoi.enable = true;
}
