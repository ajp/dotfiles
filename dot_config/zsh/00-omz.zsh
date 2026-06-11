# -----------------------------------------------------------------------------
# Oh-My-Zsh
# -----------------------------------------------------------------------------

export ZSH="$HOME/.oh-my-zsh"

# Theme — Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins  (standard: ~/.oh-my-zsh/plugins/ · custom: ~/.oh-my-zsh/custom/plugins/)
plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source "$ZSH/oh-my-zsh.sh"
