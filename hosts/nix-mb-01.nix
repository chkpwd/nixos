{
  inputs,
  pkgs,
  username,
  ...
}: {
  config = {
    programs.zsh.enable = true;
    networking = {
      hostName = "nix-mb-01";
    };

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false; # Don't update during rebuild
        cleanup = "zap"; # Uninstall all programs not declared
        upgrade = true;
      };
      global = {
        brewfile = true; # Run brew bundle from anywhere
        lockfiles = false; # Don't save lockfile (since running from anywhere)
      };
    };

    # Configure user
    local.users.${username} = {
      enable = true;
      enableCommonTools = true;
      enableDevTools = true;
      enableKubernetesTools = true;
      #home-manager = {
      #  enable = true;
      #};
    };
  };
}
