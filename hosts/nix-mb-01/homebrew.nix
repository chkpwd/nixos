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
    taps = [
      "siderolabs/tap"
      "hashicorp/tap"
      "qmk/qmk"
      "egovelox/homebrew-mozeidon"
    ];
    brews = [
      "coreutils"
      "ffmpeg"
      "bitwarden-cli"
      "talosctl"
      "talhelper"
      "awscli"
      "yt-dlp"
      "qmk/qmk/qmk"
      "ente-cli"
      "egovelox/mozeidon/mozeidon"
      "egovelox/mozeidon/mozeidon-native-app"
      # "controlplaneio-fluxcd/tap/flux-operator"
      "postgresql"
      "govc"
    ];
    casks = [
<<<<<<< HEAD
      "ollama"
=======
      "ollama-app"
>>>>>>> 4b75078891c2 (add/remove brew pkgs)
      "obs"
      "discord"
      "google-chrome"
      "itsycal"
      "iterm2"
      "autodesk-fusion"
      "zoom"
      "transmit"
      "steam"
      "audacity"
      "firefox"
      "orbstack"
      "orcaslicer"
      "spotify"
      "raspberry-pi-imager"
      "iina"
      "plex"
      "wireshark-app"
      "keycastr"
      "the-unarchiver"
      "moonlight"
      "loopback"
      "betterdisplay"
      "visual-studio-code"
      "slack"
      # "hammerspoon"
      "qbittorrent"
      "appcleaner"
      # "aldente"
      # "loopback"
      # "farrago"
      # "dash"
      # "etrecheckpro"
    ];
    masApps = {
      "Nautik" = 1672838783;
      "Twingate" = 1501592214;
      "Bitwarden" = 1352778147;
      "Wireguard" = 1451685025;
      "Microsoft Remote Desktop" = 1295203466;
      "WhatsApp" = 310633997;
      # https://github.com/mas-cli/mas/issues/321
      # "JW Library" = 672417831;
      # "NW Publisher" = 1561127070;
    };
  };
}
