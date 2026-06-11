# -----------------------------------------------------------------------------
# Environment
# -----------------------------------------------------------------------------

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew auto-update interval (daily)
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -w'
fi

# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
