{
  pkgs,
  lib,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      nil
      alejandra
      vim
    ];
    variables.EDITOR = "nvim";
  };
}
