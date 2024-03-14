{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
  # Parser
    yq
    jq
  ];
}
