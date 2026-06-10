#!/bin/bash
# Point iTerm2 at the chezmoi-managed prefs folder (~/.config/iterm2), where the
# com.googlecode.iterm2.plist is applied. Restart iTerm2 to pick it up.
set -euo pipefail

if [[ ! -d /Applications/iTerm.app ]]; then
  echo "iTerm2 not installed yet — skipping (installed via brew bundle)."
  exit 0
fi

echo "==> Configuring iTerm2 to load prefs from ~/.config/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$HOME/.config/iterm2"
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection -int 2
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile -bool true
