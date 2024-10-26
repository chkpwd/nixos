_: {
  # See https://github.com/mathiasbynens/dotfiles/blob/master/.macos
  system.activationScripts.postUserActivation.text = ''
    echo "Setting UI Defaults..."

    #- File System -#
    # Create default directory for Screenshots
    mkdir -p /Users/chkpwd/Documents/Screenshots

    # Finder: disable window animations and Get Info animations
    defaults write com.apple.finder DisableAllAnimations -bool true

    # Set HOME as the default location for new Finder windows
    # For other paths, use `PfLo` and `file:///full/path/here/`
    defaults write com.apple.finder NewWindowTarget -string "PfLo"
    defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/chkpwd/"

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    #- Gestures -#
    defaults write com.apple.trackpad.threeFingerVertSwipeGesture -int "0"
    defaults write com.apple.WindowManager.EnableTiledWindowMargins -int "0"

    #- Menu Bar -#
    # Hide items from menubar
    for domain in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*; do
        defaults write "$\{domain}" dontAutoLoad -array \
          "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
          "/System/Library/CoreServices/Menu Extras/Volume.menu" \
          "/System/Library/CoreServices/Menu Extras/User.menu"
    done

    # Show Bluetooth, AirPort, Battery, and Clock
    defaults write com.apple.systemuiserver menuExtras -array \
      "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
      "/System/Library/CoreServices/Menu Extras/AirPort.menu"

    defaults write com.apple.controlcenter Battery -int "1"
    defaults write com.apple.controlcenter Hearing -int "2"

    #- Window Management -#
    # Disable margins around tiled windows
    defaults write com.apple.WindowManager EnableTiledWindowMargins -int "0"
  '';
}
