# -----------------------------------------------------------------------------
# Docker CLI Completions
# -----------------------------------------------------------------------------

if [[ -d "$HOME/.docker/completions" ]]; then
  fpath=($HOME/.docker/completions $fpath)
  autoload -Uz compinit
  compinit
fi
