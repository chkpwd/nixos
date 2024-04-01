{
  username,
  sshPubKey,
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ];
    security.sudo.wheelNeedsPassword = false;
    openssh.authorizedKeys.keys = [
      sshPubKey
    ];
  };
}
