# Dotfiles

macOS dotfiles managed with [chezmoi](https://chezmoi.io), with packages from a
Brewfile and secrets pulled from 1Password.

## New machine

```sh
# Installs chezmoi, clones this repo, and applies everything
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ajp
```

On first run chezmoi prompts for: **name**, **git email**, **machine type**
(`personal` / `work`), and whether to **manage SSH keys from 1Password**. Then it:

1. **before** — install Xcode CLT, Rosetta, Homebrew, and 1Password (app + CLI),
   then pause until `op` can authenticate so secrets render on the first pass
2. **externals** — clone Oh-My-Zsh, Powerlevel10k, and zsh plugins (kept updated)
3. **apply dotfiles** — zsh, git, tmux, p10k, ssh, ddev, gh, iTerm2
   (secrets rendered from 1Password)
4. **after** — `brew bundle` the full Brewfile, set zsh as default shell, apply
   macOS defaults, point iTerm2 at its prefs

See **[SETUP.md](SETUP.md)** for the full walkthrough (including `op signin` and
SSH keys).

## Multiple machines

The answers above are stored per-machine, so the same repo configures each box
differently. `machine = work` enables the Brightly container aliases; `personal`
omits them. Extend the pattern with `{{ if eq .machine "work" }}…{{ end }}` in any
`.tmpl`. SSH keys are served per-machine by the 1Password SSH agent, so each box
can use its own key without anything being written to disk.

Changes you make with `chezmoi edit` / `chezmoi add` are **auto-committed and
pushed** (`[git] autoCommit/autoPush`), so machines stay in sync — `chezmoi
update` on the others pulls + applies.

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
| Tools | `dot_config/private_gh/…`, `dot_ddev/…` |
| Claude Code | `dot_claude/settings.json` (settings only — not session/auth state) |
| Packages | `Brewfile` (installed by `run_onchange_after_20-brew-bundle`) |
| Externals | Oh-My-Zsh + p10k + plugins via `.chezmoiexternal.toml` |
| Provisioning | `run_*` scripts (Homebrew, shell, macOS, iTerm2) |

## Secrets (1Password)

Templates ending in `.tmpl` pull secrets via the `op` CLI at apply time — nothing
secret is ever stored in this repo. Items follow the naming convention
**`setup - chezmoi - <machine> - <name>`** (prefix + vault set in
`.chezmoidata.yaml`), so each machine type pulls its own set — create the items
for every machine type you use (`personal` and/or `work`):

| Item (vault `Private`) | Fields | Used by |
|------------------------|--------|---------|
| `setup - chezmoi - <machine> - Forge` | `hostname` | ssh `10-personal` |

Example: a `work` machine reads `setup - chezmoi - work - Forge`; a `personal`
machine reads `setup - chezmoi - personal - Forge`. Sign in with `op signin` (or
enable the 1Password app's CLI integration) before `chezmoi apply`.

**SSH keys** are *not* templated — they're served by the **1Password SSH agent**
(enable *Settings → Developer → Use the SSH agent*). Store each key as an SSH Key
item in 1Password; the private key is never written to disk. `00-defaults` points
ssh at the agent socket.

## Packages

`Brewfile` is the single source of truth. Edit it, then `chezmoi apply` — the
`run_onchange` script re-runs `brew bundle` automatically when the file changes.
Personal apps (media/games/hardware) are commented out; uncomment per machine.
