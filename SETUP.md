# New Machine Setup

Provisioning a fresh macOS machine with chezmoi.

## 1. Prereqs you bring with you

- **1Password account creds** (email + Secret Key, or your Emergency Kit). You do
  **not** need 1Password pre-installed — the bootstrap installs the app + CLI for
  you and then pauses: open 1Password, sign in, and under *Settings → Developer*
  enable **both** "Integrate with 1Password CLI" (secrets) and "Use the SSH agent"
  (ssh keys), then press Enter. Secrets render on the first pass.
- **SSH keys** are served by the **1Password SSH agent** — the private key lives
  in 1Password and is never written to disk. Store each key as an **SSH Key** item
  (1Password can generate one for you), then add its **public** key to GitHub and
  the Forge server. Nothing to copy between machines.
  - GitHub itself needs no key — `gh auth login` uses HTTPS + keychain.

## 2. One command

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ajp
```

This installs chezmoi, clones `github.com/ajp/dotfiles`, prompts for **name,
git email, machine type (personal/work), and whether to sign commits**, then runs
the full flow (Homebrew → externals/OMZ → dotfiles → brew bundle → shell → macOS →
iTerm2).

> If Xcode Command Line Tools aren't installed, the first run will trigger their
> install and stop — finish that, then re-run the command.

> The `brew bundle` step is long (downloads GBs of apps) and prints as it goes.

## 3. If secrets didn't populate

If you ran apply before 1Password CLI was ready, the ssh templates render empty.
Fix:

```sh
op signin            # or enable the app integration (step 1)
chezmoi apply
```

Required 1Password items (vault `Private`), named
`setup - chezmoi - <machine> - <name>` where `<machine>` is `personal` or `work`.
Create a set for each machine type you use:

| Item | Fields |
|------|--------|
| `setup - chezmoi - <machine> - Forge` | `hostname` |

Create it quickly with `op` (repeat with `<machine>` = `personal` then `work`):

```sh
M=personal   # or: M=work
op item create --category="Secure Note" --vault=Private \
  --title="setup - chezmoi - $M - Forge" hostname=YOUR_HOST
```

(SSH keys are separate — they're SSH Key items served by the agent, not created
here. See *Setting up an SSH key* below.)

## 4. Manual follow-ups

```sh
gh auth login                 # GitHub HTTPS auth (writes hosts.yml + keychain)
```

- **iTerm2**: restart it once to load the managed prefs. Set the profile font to
  a Nerd Font (e.g. *MesloLGS NF*) or Powerlevel10k glyphs render wrong.

## 5. Reload

```sh
exec zsh      # or just open a new terminal
```

Some macOS defaults need a logout/restart to fully apply.

---

## Setting up an SSH key (1Password SSH agent)

Keys live in 1Password and are served by its SSH agent — never written to disk.
Make a separate key per machine type so they can be revoked independently.

1. In 1Password: **New Item → SSH Key → Generate** (Ed25519). Name it
   **`setup - chezmoi - <machine> - SSH key`** (e.g. `… - work - SSH key`) so
   commit signing can find it.
2. Copy the **public** key from the item and add it to:
   - GitHub: `gh ssh-key add - --title "work-$(hostname)"` (paste), or the web UI.
     For commit signing, also add it again as a **Signing Key** on GitHub.
   - Forge: append it to `~/.ssh/authorized_keys` on the server
3. Ensure *Settings → Developer → Use the SSH agent* is on. Test: `ssh -T git@github.com`.

This is **additive** — adding the work key doesn't touch your personal key.

## Rotating a key

1. Generate a new SSH Key item in 1Password (step 1 above).
2. Add the new public key to GitHub + Forge; confirm it works.
3. Remove the old public key from GitHub + Forge, and archive the old 1Password item.

No `chezmoi apply` needed — the agent picks up the new key from 1Password directly.

---

## Updating later

```sh
chezmoi update         # git pull + apply
# or edit locally:
chezmoi cd             # -> source repo
chezmoi edit ~/.zshrc  # change a file
chezmoi diff && chezmoi apply
```
