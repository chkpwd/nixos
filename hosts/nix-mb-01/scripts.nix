_: {
  # See https://github.com/mathiasbynens/dotfiles/blob/master/.macos
  system.activationScripts.postUserActivation.text = ''
    echo "Setting UI Defaults..."

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
  '';
}
