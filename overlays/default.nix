# This file defines overlays
{inputs, ...}: {
  additions = _final: _prev: {};

  modifications = _final: _prev: {};

  lix-overlay = inputs.lix-module.overlays.default;

  # The unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = true;
    };
  };
}
