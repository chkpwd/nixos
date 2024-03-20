{
  username,
  sshPubKey,
  ...
}: {
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups =
      [
        "wheel"
      ];

    openssh.authorizedKeys.keys = [
      sshPubKey
    ];
  };
}
