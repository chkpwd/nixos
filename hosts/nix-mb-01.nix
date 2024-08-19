{
  inputs,
  pkgs,
  username,
  sshPubKey,
  config,
  ...
}: {
  networking = {
    hostName = "nix-mb-01";
    knownNetworkServices = ["Wi-Fi"];
  };

  system = {
    activationScripts.postActivation.text = ''
      sudo chsh -s /run/current-system/sw/bin/zsh chkpwd
    '';
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };

  programs.zsh.enable = true;

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [sshPubKey];
  };

  local.packages = {
    enableCommonTools = true;
    enableDevTools = true;
    enableKubernetesTools = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "zap";
      upgrade = true;
    };
    global = {
      brewfile = true;
      lockfiles = false;
    };
    brews = [
      # Some of alfred's workflows need these path to be static
      "php"
      "ruby"
      "jq"
      "bitwarden-cli"
      "yt-dlp"
      "ffmpeg"
    ];
    casks = [
      "iterm2"
      "autodesk-fusion"
      "zoom"
      "transmit"
      "visual-studio-code"
      "steam"
      "wins"
      "audacity"
      # installed via other mediums
      #"aldente"
      #"alfred"
      #"dash"
      "firefox"
      "discord"
      "orbstack"
      "keyboardcleantool"
      "orcaslicer"
      "spotify"
      "postman"
      "raspberry-pi-imager"
      "usr-sse2-rdm"
      "vlc"
      "plex"
      "stats"
      "rectangle"
      "ente-auth"
    ];
    masApps = {
      "Nautik" = 1672838783;
      "Twingate" = 1501592214;
      "Bitwarden" = 1352778147;
      "Wireguard" = 1451685025;
      "Microsoft Remote Desktop" = 1295203466;
      "Amphetamine" = 937984704;
      "WhatsApp" = 310633997;
      # "JW Library" = 672417831;
      # "NW Publisher" = 1561127070;
    };
  };
}
