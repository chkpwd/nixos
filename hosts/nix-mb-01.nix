<<<<<<< Updated upstream
{inputs, ...}: {
  # Enable Nix Daemon
  nix.useDaemon = true;

  # Sudo Touch ID authentication
  security.pam.enableSudoTouchIdAuth = true;
=======
{
  pkgs,
  username,
  ...
}: {
  config = {
    networking = {
      hostName = "nix-mb-01";
    };

    environment.sessionVariables = {
      FLAKE = "/home/${username}/code/nixos";
    };

    # Enable Dynamic Linker
    programs.nix-ld.enable = true;

    # Configure user
    local.users.${username} = {
      enable = true;
      enableCommonTools = true;
      enableDevTools = true;
      enableKubernetesTools = true;
      home-manager = {
        enable = true;
      };
    };
  };
>>>>>>> Stashed changes
}
