#!/bin/bash
# Make Homebrew's zsh the default login shell.
set -euo pipefail

BREW_ZSH="$(brew --prefix)/bin/zsh"

if [[ ! -x "$BREW_ZSH" ]]; then
  echo "Homebrew zsh not found at $BREW_ZSH — skipping (run brew bundle first)."
  exit 0
fi

if ! grep -qxF "$BREW_ZSH" /etc/shells; then
  echo "==> Adding $BREW_ZSH to /etc/shells (needs sudo)"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$SHELL" != "$BREW_ZSH" ]]; then
  echo "==> Changing default shell to $BREW_ZSH"
  chsh -s "$BREW_ZSH"
fi
