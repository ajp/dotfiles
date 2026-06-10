#!/bin/bash
# Install Oh-My-Zsh + Powerlevel10k + plugins. --keep-zshrc so it never touches
# the chezmoi-managed ~/.zshrc. Idempotent: skips anything already present.
set -euo pipefail

ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$ZSH_DIR/custom"

if [[ ! -d "$ZSH_DIR" ]]; then
  echo "==> Installing Oh-My-Zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

clone_if_missing() {
  local repo="$1" dest="$2"
  if [[ ! -d "$dest" ]]; then
    echo "==> Cloning $(basename "$dest")"
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_if_missing https://github.com/romkatv/powerlevel10k.git        "$ZSH_CUSTOM/themes/powerlevel10k"
clone_if_missing https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_if_missing https://github.com/zsh-users/zsh-completions         "$ZSH_CUSTOM/plugins/zsh-completions"
