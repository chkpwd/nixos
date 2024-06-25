{
  inputs,
  pkgs,
  sshPubKey,
  ...
}: {
  config = {
    networking.hostName = nix-mb-01;

    users.users.scotte = {
      name = "chkpwd";
      home = "/Users/chkpwd";
      shell = pkgs.zsh;
      packages = [pkgs.home-manager];
      openssh.authorizedKeys.keys = sshPubKey;
    };

    homebrew = {
      taps = [
      ];
      brews = [
      ];
      casks = [
        "alacritty"
      ];
      masApps = {};
    };
  };
}
