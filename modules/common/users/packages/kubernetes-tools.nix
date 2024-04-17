{
  lib,
  config,
  username,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.users.${username};
in {
  options.local.users.${username} = {
    enableKubernetesTools =
      mkEnableOption "Enable dev tools";
  };

  config = mkIf cfg.enableKubernetesTools {
    users.users.${username}.packages = with pkgs; [
      kubecolor
      minikube
      stern
      viddy
      k9s
      vcluster
      nova
      pluto
      kubectl
      krew
      kubectx
      kubernetes-helm
      kustomize
      cmctl
    ];
  };
}
