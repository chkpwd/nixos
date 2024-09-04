{
  inputs,
  pkgs,
  username,
  sshPubKey,
  config,
  ...
}: {
  imports = [./macos-defaults.nix];

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

  programs = {
    zsh.enable = true;
  };

  users.users.${username} = {
    name = "${username}";
    home = "/Users/${username}";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [sshPubKey];
  };

  # home-manager = {
  #   users.${username} = {
  #     imports = [inputs.nixcord.homeManagerModules.nixcord];
  #     # programs.nixcord = {
  #     #   enable = true;
  #     #   vencord.enable = true;
  #     #   discord.enable = false;
  #     #   config.plugins = {
  #     #     alwaysAnimate.enable = true;
  #     #   };
  #     # };
  #   };
  # };

  local = {
    packages = {
      enableCommonTools = true;
      enableDevTools = true;
      enableKubernetesTools = true;
    };
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
    brews = [];
    casks = [
      "lm-studio"
      "ollama"
      "itsycal"
      "iterm2"
      "autodesk-fusion"
      "zoom"
      "transmit"
      "steam"
      "rectangle"
      "audacity"
      #"aldente"
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
      "ente-auth"
      "wireshark"
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
