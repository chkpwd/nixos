_: {
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
    brews = [ "ffmpeg" ];
    casks = [
      "ollama"
      "itsycal"
      "iterm2"
      "autodesk-fusion"
      "zoom"
      "transmit"
      "steam"
      "gimp"
      "audacity"
      "firefox"
      "zen-browser"
      "discord"
      "orbstack"
      "orcaslicer"
      "spotify"
      "raspberry-pi-imager"
      "usr-sse2-rdm"
      "vlc"
      "plex"
      "ente-auth"
      "wireshark"
      "keycastr"
      "the-unarchiver"
      "moonlight"
      "loopback"
      "betterdisplay"
      "visual-studio-code"
      "slack"
      "rectangle"
      "hyperkey"
      # "postman"
      # "loopback"
      # "farrago"
      # "aldente"
      # "dash"
      # "etrecheckpro"
    ];
    masApps = {
      "Nautik" = 1672838783;
      "Twingate" = 1501592214;
      "Bitwarden" = 1352778147;
      "Wireguard" = 1451685025;
      "Microsoft Remote Desktop" = 1295203466;
      "Amphetamine" = 937984704;
      "WhatsApp" = 310633997;
      # https://github.com/mas-cli/mas/issues/321
      # "JW Library" = 672417831;
      # "NW Publisher" = 1561127070;
    };
  };
}
