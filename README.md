# Dotfiles

macOS dotfiles managed with [chezmoi](https://chezmoi.io), with packages from a
Brewfile and secrets pulled from 1Password.

## New machine

```sh
# Installs chezmoi, clones this repo, and applies everything
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ajp
```

You'll be prompted for your name + email (for git), and chezmoi will:

1. **before** — install Xcode CLT, Rosetta, Homebrew, and 1Password CLI
2. **apply dotfiles** — zsh, git, tmux, p10k, ssh, ddev, gh, rclone, iTerm2
   (secrets rendered from 1Password)
3. **after** — `brew bundle` the full Brewfile, install Oh-My-Zsh + Powerlevel10k,
   set zsh as default shell, apply macOS defaults, point iTerm2 at its prefs

See **[SETUP.md](SETUP.md)** for the full walkthrough (including `op signin` and
SSH keys).

## Daily use

```sh
chezmoi edit ~/.zshrc      # edit a managed file (opens the source)
chezmoi diff               # preview pending changes
chezmoi apply              # apply changes
chezmoi cd                 # jump to the source repo; git pull/commit/push here
chezmoi update             # git pull + apply in one step
```

Add a new file to management: `chezmoi add ~/.config/foo/bar`.

## What's managed

| Area | Files |
|------|-------|
| Shell | `dot_zshrc`, `dot_zprofile`, `dot_zshrc.local`, `dot_p10k.zsh` |
| Git | `dot_gitconfig.tmpl` (identity from prompt), `dot_gitignore_global` |
| Terminal | `dot_tmux.conf`, `dot_config/iterm2/…` |
| SSH | `private_dot_ssh/config`, `…/config.d/00-defaults`, `…/10-personal.tmpl` |
| Tools | `dot_config/private_gh/…`, `dot_config/private_rclone/…`, `dot_ddev/…` |
| Packages | `Brewfile` (installed by `run_onchange_after_20-brew-bundle`) |
| Provisioning | `run_*` scripts (Homebrew, OMZ, shell, macOS, iTerm2) |

## Secrets (1Password)

Templates ending in `.tmpl` pull secrets via the `op` CLI at apply time — nothing
secret is ever stored in this repo. Required 1Password items:

| Item (vault `Private`) | Fields | Used by |
|------------------------|--------|---------|
| `rclone telescope-s3` | `access_key_id`, `secret_access_key` | rclone config |
| `Forge server` | `hostname` | ssh `10-personal` |

Sign in with `op signin` (or enable the 1Password app's CLI integration) before
`chezmoi apply`.

## Packages

`Brewfile` is the single source of truth. Edit it, then `chezmoi apply` — the
`run_onchange` script re-runs `brew bundle` automatically when the file changes.
Personal apps (media/games/hardware) are commented out; uncomment per machine.
