# -----------------------------------------------------------------------------
# NVM (Node Version Manager)
# -----------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Auto-switch Node on cd when a directory has a .nvmrc.
# Uses the pinned version if installed; warns instead of auto-installing.
if command -v nvm >/dev/null 2>&1; then
  autoload -U add-zsh-hook
  _load_nvmrc() {
    local nvmrc_path nvmrc_version
    nvmrc_path="$(nvm_find_nvmrc)"
    if [ -n "$nvmrc_path" ]; then
      nvmrc_version="$(nvm version "$(cat "$nvmrc_path")")"
      if [ "$nvmrc_version" = "N/A" ]; then
        echo "nvm: $(cat "$nvmrc_path") not installed — run 'nvm install' here" >&2
      elif [ "$nvmrc_version" != "$(nvm version)" ]; then
        nvm use --silent
      fi
    elif [ "$(nvm version)" != "$(nvm version default)" ]; then
      nvm use default --silent
    fi
  }
  add-zsh-hook chpwd _load_nvmrc
  _load_nvmrc
fi

# -----------------------------------------------------------------------------
# Thefuck
# -----------------------------------------------------------------------------

if command -v thefuck &>/dev/null; then
  eval $(thefuck --alias)
fi
