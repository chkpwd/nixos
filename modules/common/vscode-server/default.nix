{
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.vscode-server;
in {
  options.modules.vscode-server = {
    enable = mkEnableOption "Enable VSCode Server";
  };

  imports = [inputs.vscode-server.nixosModules.default];

  config = mkIf cfg.enable {
    services.vscode-server.enable = true;
  };
}
