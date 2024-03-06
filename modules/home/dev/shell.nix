{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fd
    file
    ripgrep
    sops
  ];

  programs = {
    bat.enable = true;
    lsd.enable = true;
    lsd.enableAliases = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      fileWidgetOptions = ["--preview 'bat --color=always {}'"];
    };
  };
}
