{
  pkgs,
  inputs,
  username,
  sshPubKey,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit username;
      inherit sshPubKey;
    };

    sharedModules = [
      {
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion = "23.11";
          packages = with pkgs; [
            wget
            curl
          ];
        };

        programs.home-manager.enable = true;
        services.ssh-agent.enable = true;
      }
    ];
  };
}
