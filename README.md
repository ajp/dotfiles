# Dotfiles

macOS dotfiles managed with [chezmoi](https://chezmoi.io), with packages from a
Brewfile and secrets pulled from 1Password.

## New machine

**You don't clone this repo by hand** — `chezmoi init` does it for you. One
command installs chezmoi, clones `github.com/ajp/dotfiles` into its own source
dir (`~/.local/share/chezmoi`), and applies everything:

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ajp
```

**Before you run it**, in 1Password (vault `Private`) create the SSH Key item
`setup - chezmoi - SSH key` (used by the ssh agent + commit signing). That's the
only required item — see [Secrets](#secrets-1password).

On first run chezmoi prompts for: **name**, **git email**, **machine type**
(`personal` / `work`), and whether to **sign git commits** with 1Password. Then it:

1. **before** — install Xcode CLT, Rosetta, Homebrew, and 1Password (app + CLI),
   then pause until `op` can authenticate so secrets render on the first pass
2. **externals** — clone Oh-My-Zsh, Powerlevel10k, and zsh plugins (kept updated)
3. **apply dotfiles** — zsh, git, tmux, p10k, ssh, ddev, gh, iTerm2, editors
   (secrets rendered from 1Password)
4. **after** — `brew bundle` the common + per-machine Brewfile, set zsh as default
   shell, apply macOS defaults, point iTerm2 at its prefs

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

The source repo lives at `~/.local/share/chezmoi` (get there with `chezmoi cd`).
You edit there (or via `chezmoi edit`), apply to `$HOME`, and commits are
auto-pushed so other machines can `chezmoi update`.

```sh
chezmoi edit ~/.zshrc      # edit a managed file (opens its source, e.g. dot_zshrc)
chezmoi diff               # preview what apply would change
chezmoi apply              # apply source -> $HOME
chezmoi add ~/.config/foo  # start managing a new file (copies it into the source)
chezmoi cd                 # drop into the source repo for git work; `exit` to leave
chezmoi update             # git pull + apply (use on your *other* machines)
chezmoi managed            # list every path chezmoi manages
```

Typical change: `chezmoi edit ~/.zshrc` → `chezmoi apply`. Because `autoCommit`/
`autoPush` are on, that edit is committed and pushed automatically; run `chezmoi
update` on your other machines to pull it in.

## What's managed

| Area | Files |
|------|-------|
| Shell | `dot_zshrc`, `dot_zprofile`, `dot_zshrc.local`, `dot_p10k.zsh` |
| Git | `dot_gitconfig.tmpl` (identity from prompt; optional 1Password commit signing), `dot_gitignore_global` |
| Terminal | `dot_tmux.conf`, `dot_config/iterm2/…` |
| SSH | `private_dot_ssh/config`, `…/config.d/00-defaults`, `…/10-personal.tmpl` |
| Tools | `dot_config/private_gh/…`, `dot_ddev/…` |
| Editors | `dot_claude/settings.json`, `Library/.../Code/User/settings.json` (settings only) |
| Packages | `Brewfile` (common) + `Brewfile.{work,personal}` (per machine) |
| Externals | Oh-My-Zsh + p10k + plugins via `.chezmoiexternal.toml` |
| Provisioning | `run_*` scripts (Homebrew, shell, macOS, iTerm2) |

## Secrets (1Password)

Secrets are pulled from 1Password via `op` at apply time — nothing secret is
stored in this repo. Items live in the `Private` vault and follow the convention
**`setup - chezmoi - [<machine> -] <name>`** (prefix + vault set in
`.chezmoidata.yaml`). Only the **SSH key** is required; Forge is optional:

| Item (vault `Private`) | Fields | Used by |
|------------------------|--------|---------|
| `setup - chezmoi - SSH key` | SSH Key item (`public key`) | ssh agent + commit signing (shared across machines) |
| `setup - chezmoi - <machine> - Forge` | `hostname` | ssh `10-personal` *(optional — disabled by default)* |

Example: a `work` machine reads `setup - chezmoi - work - Forge`; a `personal`
machine reads `setup - chezmoi - personal - Forge`. Sign in with `op signin` (or
enable the 1Password app's CLI integration) before `chezmoi apply`.
(`.chezmoitemplates/op-read` builds these references.)

**SSH keys** are served by the **1Password SSH agent** (enable *Settings →
Developer → Use the SSH agent*) — the private key is never written to disk.
Name the **SSH Key** item `setup - chezmoi - SSH key` (one key shared across
machines); if you opt into commit signing, git uses that item's public key with
`op-ssh-sign`. (Want per-machine keys instead? Re-add the `<machine>` segment.)

## Packages

`Brewfile` holds the common packages; `Brewfile.work` and `Brewfile.personal`
hold per-machine extras (media/games live in `Brewfile.personal`). The
`run_onchange` script installs `Brewfile` then `Brewfile.<machine>` and re-runs
automatically when either changes. Edit the relevant file, then `chezmoi apply`.
