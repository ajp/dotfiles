# New Machine Setup

Provisioning a fresh macOS machine with chezmoi.

## 1. Prereqs you bring with you

- **1Password**: sign into the desktop app, and enable
  *Settings → Developer → Integrate with 1Password CLI* (so `op` works without a
  separate signin). The secret templates need this.
- **SSH keys**: two options —
  - *Automated*: store your private key as a 1Password **document** in an item
    named `SSH id_ed25519`, then answer **yes** to "Manage SSH keys?" at init.
    chezmoi writes `~/.ssh/id_ed25519` (0600) on apply.
    Add more keys (e.g. `id_rsa`) the same way.
  - *Manual*: answer **no**, then copy keys over securely (AirDrop / `scp`) and
    `chmod 600 ~/.ssh/id_* ~/.ssh/*.pem`.
  - GitHub itself needs no key — `gh auth login` uses HTTPS + keychain.

## 2. One command

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ajp
```

This installs chezmoi, clones `github.com/ajp/dotfiles`, prompts for **name,
git email, machine type (personal/work), and SSH-key management**, then runs the
full flow (Homebrew → externals/OMZ → dotfiles → brew bundle → shell → macOS →
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
| `setup - chezmoi - <machine> - SSH id_ed25519` | document = private key (only if you opted in) |
| `setup - chezmoi - <machine> - Forge` | `hostname` |

Create them quickly with `op` (repeat with `<machine>` = `personal` then `work`):

```sh
M=personal   # or: M=work
# generate a fresh key and store the private key in 1Password
ssh-keygen -t ed25519 -C "$M $(date +%Y-%m)" -f ~/.ssh/id_ed25519
op document create ~/.ssh/id_ed25519 --vault=Private \
  --title="setup - chezmoi - $M - SSH id_ed25519"
op item create --category="Secure Note" --vault=Private \
  --title="setup - chezmoi - $M - Forge" hostname=YOUR_HOST
```

Then add the **public** key (`~/.ssh/id_ed25519.pub`) to GitHub and the Forge
server's `authorized_keys`.

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

## Rotating SSH keys

1. Generate a replacement and overwrite the 1Password document:
   ```sh
   M=personal   # or work
   ssh-keygen -t ed25519 -C "$M $(date +%Y-%m)" -f ~/.ssh/id_ed25519
   op document edit "setup - chezmoi - $M - SSH id_ed25519" ~/.ssh/id_ed25519 --vault=Private
   ```
2. Add the new `~/.ssh/id_ed25519.pub` to GitHub + the Forge server, and remove
   the old key from both.
3. On your **other** machines: `chezmoi apply` re-pulls the new key from 1Password.

---

## Updating later

```sh
chezmoi update         # git pull + apply
# or edit locally:
chezmoi cd             # -> source repo
chezmoi edit ~/.zshrc  # change a file
chezmoi diff && chezmoi apply
```
