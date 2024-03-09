{
  pkgs,
  config,
  username,
  inputs,
  ...
}: {
  virtualisation = {
    docker = {
      enable = true;
    };
  };
  users.users.${username}.extraGroups = [ "docker" ];
}
