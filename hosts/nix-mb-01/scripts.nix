_: {
  # See https://github.com/mathiasbynens/dotfiles/blob/master/.macos
  system.activationScripts.postUserActivation.text = ''
    echo "Setting UI Defaults..."

    #- File System -#
    # Create default directory for Screenshots
    mkdir -p /Users/chkpwd/Documents/Screenshots
  '';
}
