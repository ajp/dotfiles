# New Machine Setup

Provisioning a fresh macOS machine with chezmoi.

## 1. Set up 1Password first (do this and the rest just flows)

Everything secret comes from 1Password via the `op` CLI. If `op` can read your
vault before you run the installer, the whole thing completes in one pass. If
not, the installer stops cleanly at the 1Password step and tells you to do this —
so either way you end up here.

**Fastest (one pass):** before running the installer, install the **1Password
app** (download from [1password.com](https://1password.com/downloads/mac/) on a
bare Mac), then:

1. Sign in (email + Secret Key / Emergency Kit).
2. **Settings → Developer →** enable **both** "Integrate with 1Password CLI" and
   "Use the SSH agent".
3. **Quit 1Password (⌘Q) and reopen it** — the toggles only activate after a
   restart. Unlock it.
4. Create the signing/auth key: **New Item → SSH Key → Generate** (Ed25519),
   titled **`setup - chezmoi - SSH key`**, in your **`Personal`** vault.

**Verify** (install the CLI first if needed: `brew install --cask 1password-cli`):
```sh
op vault list        # should Touch-ID prompt and list your vaults
```
Once that lists vaults, the installer's 1Password check passes on the first try.

> SSH keys are served by the **1Password SSH agent** — the private key never
> touches disk. Afterward, add the key's **public** half to GitHub (as both an
> Authentication and a Signing key). GitHub *cloning* needs no key —
> `gh auth login` uses HTTPS.

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

## 3. If the run stopped at the 1Password step

If `op` wasn't ready, the installer prints setup instructions and **exits cleanly**
(it no longer hangs or pauses). Do step 1 — sign in, enable both toggles,
**restart the 1Password app**, confirm `op vault list` lists your vaults — then
resume:

```sh
chezmoi apply
```

The only secret rendered at apply time is the commit-signing key
(`setup - chezmoi - SSH key` in the `Personal` vault), and only if you opted into
signing.

**Optional:** the Forge host in `10-personal` is disabled by default. To enable
it, create `setup - chezmoi - <machine> - Forge` (field `hostname`) and restore
the Host block (see notes in that file):

```sh
M=work   # or personal
op item create --category="Secure Note" --vault=Personal \
  --title="setup - chezmoi - $M - Forge" hostname=YOUR_HOST
```

(SSH keys are separate — SSH Key items served by the agent. See *Setting up an
SSH key* below.)

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
   **`setup - chezmoi - SSH key`** (one key shared across machines) so commit
   signing can find it.
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
