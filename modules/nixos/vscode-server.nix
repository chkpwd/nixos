{
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.vscode-server;
in {
  options.local.vscode-server = {
    enable = mkEnableOption "Enable VSCode Server";
  };

  imports = [inputs.vscode-server.nixosModules.default];

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
