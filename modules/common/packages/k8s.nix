{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.local.packages;
in
{
  options.local.packages = {
    enableKubernetesTools = mkEnableOption "Enable Kubernetes tools";
  };

  config = mkIf cfg.enableKubernetesTools {
    users.users.${config.crossSystem.username}.packages = with pkgs; [
      hubble
      kubecolor
      viddy
      nova
      pluto
      kubectl
      kubernetes-helm
      kustomize
      cmctl
      unstable.fluxcd
      cilium-cli
      k9s
      kind
    ];
  };
}
