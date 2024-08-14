#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

cleanup() {
  result=$?
  rm -rf "${WORK_DIR}"
  exit ${result}
}

trap cleanup EXIT ERR

WORK_DIR=$(mktemp -d)

if [[ $(uname) == "Darwin" ]]; then
  if ! $(xcode-select --print-path &> /dev/null); then
    xcode-select --install &> /dev/null
    until $(xcode-select --print-path &> /dev/null); do
      sleep 5
    done
  fi
  softwareupdate --install-rosetta --agree-to-license

  if ! test -f /opt/homebrew/bin/brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "eval $(/opt/homebrew/bin/brew shellenv)" >>~/.zprofile
  fi

  if ! command -v nix &>/dev/null; then
    curl -sL -o nix-installer https://install.determinate.systems/nix/nix-installer-aarch64-darwin
    chmod +x nix-installer

    ./nix-installer install macos \
      --logger pretty \
      --extra-conf "sandbox = false" \
      --extra-conf "experimental-features = nix-command flakes" \
      --extra-conf "trusted-users = chkpwd"
    ./nix-installer self-test --logger pretty
    rm ./nix-installer
  fi
fi

set +o nounset
# shellcheck disable=SC1091
if [[ $(uname) == "Darwin" ]]; then
    source "/etc/bashrc"
fi

if [[ ! -d ~/.local/nix-config ]]; then
  mkdir -p ~/.local
  git clone https://github.com/chkpwd/nixos.git ~/.local/nix-config
fi

for i in nix/nix.conf shells zshenv; do
  if [ -f /etc/$i ]; then
    sudo mv /etc/$i /etc/$i.before-nix-darwin
  fi
done
