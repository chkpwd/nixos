{
  pkgs,
  username,
  ...
}: {
  local.vscode-server.enable = true;

  networking = {
    hostName = "nix-wsl-01";
  };

  environment = {
    systemPackages = with pkgs; [deploy-rs];
  };

  # Configure user
  local.users.${username} = {
    enable = true;
    enableDevTools = true;
    home-manager = {
      enable = true;
    };
  };

  local.wsl.enable = true;

  local.docker.enable = true;

  local.sops = {
    enable = true;
    file = {
      source = ../secrets/default.yml;
    };
    age = {
      source = "/mnt/c/users/chkpwd/nix-agekey.txt";
      destination = "/etc/sops/age/nix.txt";
    };
  };

  local.chezmoi.enable = true;
}
