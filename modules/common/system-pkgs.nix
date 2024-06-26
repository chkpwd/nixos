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
    variables.EDITOR = lib.mkDefault "nano"; #TODO: change to vim
  };
}
