{ config, username, sshPubKey, ... }: {
  users = {
    mutableUsers = false;
    users.${username} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      openssh.authorizedKeys.keys = [sshPubKey];
    };
  };
}
