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
    Add more keys (id_rsa, telescope.pem) the same way.
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

If you ran apply before 1Password CLI was ready, the rclone/ssh templates render
empty. Fix:

```sh
op signin            # or enable the app integration (step 1)
chezmoi apply
```

Required 1Password items (vault `Private`), named
`setup - chezmoi - <machine> - <name>` where `<machine>` is `personal` or `work`.
Create a set for each machine type you use:

| Item | Fields |
|------|--------|
| `setup - chezmoi - <machine> - rclone telescope-s3` | `access_key_id`, `secret_access_key` |
| `setup - chezmoi - <machine> - Forge` | `hostname` |
| `setup - chezmoi - <machine> - SSH id_ed25519` | document = private key (only if you opted in) |

Create them quickly with `op` (repeat with `<machine>` = `personal` then `work`):

```sh
M=personal   # or: M=work
op item create --category="API Credential" --vault=Private \
  --title="setup - chezmoi - $M - rclone telescope-s3" \
  access_key_id=YOUR_KEY secret_access_key=YOUR_SECRET
op item create --category="Secure Note" --vault=Private \
  --title="setup - chezmoi - $M - Forge" hostname=YOUR_HOST
# only if managing the key:
op document create ~/.ssh/id_ed25519 --vault=Private \
  --title="setup - chezmoi - $M - SSH id_ed25519"
```

## 4. Manual follow-ups

```sh
gh auth login                 # GitHub HTTPS auth (writes hosts.yml + keychain)
```

- **iTerm2**: restart it once to load the managed prefs. Set the profile font to
  a Nerd Font (e.g. *MesloLGS NF*) or Powerlevel10k glyphs render wrong.
- **rclone**: prefers `op` creds. To use the AWS profile instead, set
  `env_auth = true` in the template and remove the key fields.

## 5. Reload

```sh
exec zsh      # or just open a new terminal
```

Some macOS defaults need a logout/restart to fully apply.

---

## Updating later

```sh
chezmoi update         # git pull + apply
# or edit locally:
chezmoi cd             # -> source repo
chezmoi edit ~/.zshrc  # change a file
chezmoi diff && chezmoi apply
```
