{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    file
    ripgrep
  ];
}
