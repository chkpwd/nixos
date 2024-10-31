{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      nil
      nixd
    ];
    variables.EDITOR = "nvim";
  };
}
