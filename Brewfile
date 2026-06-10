# Brewfile - Managed by dotfiles
# Install everything:   brew bundle --file=Brewfile
# Re-dump from system:  brew bundle dump --force --describe --file=Brewfile
#
# Convention: dev + productivity essentials are active. Personal apps
# (media, games, hardware utilities, backup) are commented out so a fresh
# machine only installs what's needed for work. Uncomment what you want.

# =============================================================================
# Taps
# =============================================================================
tap "homebrew/bundle"
tap "homebrew/services"
tap "ddev/ddev"
tap "edde746/plezy", "https://github.com/edde746/plezy"
tap "reebz/claude-battery"

# =============================================================================
# CLI Tools & Runtimes (formulae)
# =============================================================================

# Shell & prompt
brew "powerlevel10k"      # Zsh theme
brew "thefuck"            # Correct mistyped console commands
brew "tmux"               # Terminal multiplexer

# Dev tooling
brew "gh"                 # GitHub CLI
brew "lazygit"            # Git TUI
brew "lazydocker"         # Docker TUI
brew "git-filter-repo"    # Rewrite git history
brew "ddev/ddev/ddev"     # Local PHP/Craft dev environments
brew "mkcert"             # Locally trusted dev certificates
brew "watchman"           # Watch files and trigger actions

# Languages & package managers
brew "node"
brew "yarn"
brew "yarn-completion"
brew "composer"           # PHP
brew "cocoapods"          # Cocoa/iOS
brew "ansible"            # Automation

# Cloud / infra
brew "awscli"
brew "rclone"             # Cloud storage sync
brew "rsync"
brew "meilisearch"        # Full-text search engine
brew "ollama", restart_service: :changed   # Local LLMs

# Databases
brew "mysql", restart_service: :changed
brew "mysql@8.4"

# Media / files
brew "ffmpeg"
brew "imagemagick"
brew "yt-dlp"             # Audio/video downloader
brew "wget"
brew "nss"
brew "mist-cli"           # Download macOS installers

# Recommended modern CLI replacements (not yet installed — uncomment to add)
# brew "bat"             # Better cat
# brew "eza"             # Modern ls
# brew "fd"              # Fast find
# brew "ripgrep"         # Fast grep
# brew "fzf"             # Fuzzy finder
# brew "zoxide"          # Smarter cd
# brew "jq"              # JSON processor
# brew "yq"              # YAML processor
# brew "htop"
# brew "btop"
# brew "tldr"

# =============================================================================
# Applications (Casks)
# =============================================================================

# --- Development ---
cask "visual-studio-code"
cask "cursor"
cask "sublime-text"
cask "iterm2"
cask "github"             # GitHub Desktop
cask "gitify"             # GitHub notifications in menu bar
cask "tower"              # Git client
cask "kaleidoscope"       # Diff/merge tool
cask "sequel-ace"         # MySQL GUI
cask "querious"           # MySQL GUI
cask "tableplus"          # Database GUI
cask "bruno"              # API client
cask "proxyman"           # HTTP debugging proxy
cask "ngrok"              # Tunnels to localhost
cask "expo-orbit"         # Expo builds/simulators
cask "minisim"            # iOS/Android simulators launcher
cask "xcodes-app"         # Manage Xcode versions
cask "docker-desktop"
cask "transmit"           # File transfer (SFTP/S3)
cask "figma"              # Design
cask "sizzy"              # Responsive design testing

# --- AI ---
cask "claude"
cask "claude-code"
cask "reebz/claude-battery/claude-battery"

# --- Productivity & Utilities ---
cask "1password"
cask "1password-cli"
cask "alfred"             # Launcher
cask "bartender"          # Menu bar organizer
cask "bettertouchtool"    # Input customization
cask "hazel"              # Automated file organization
cask "moom"               # Window management
cask "wispr-flow"         # Voice-to-text dictation
cask "istat-menus"        # System monitor
cask "monitorcontrol"     # External monitor brightness/volume
cask "daisydisk"          # Disk space visualizer
cask "the-unarchiver"
cask "imageoptim"
cask "kap"                # Screen recorder
cask "droplr"             # Screenshot/sharing
cask "caffeine"           # Prevent sleep
cask "mouseless"          # Keyboard mouse control
cask "quitter"            # Auto-hide/quit idle apps

# --- Browsers ---
cask "brave-browser"
cask "firefox"
cask "google-chrome"
cask "zen"

# --- Communication ---
cask "slack"
cask "discord"
cask "signal"
cask "microsoft-teams"
cask "whatsapp"
cask "zoom"

# --- Networking / VPN ---
cask "tailscale-app"
cask "nordvpn"

# --- Fonts (needed for Powerlevel10k glyphs) ---
cask "font-meslo-lg-nerd-font"
cask "font-jetbrains-mono-nerd-font"
cask "font-fira-code-nerd-font"

# =============================================================================
# Personal apps — commented out (uncomment per machine as desired)
# =============================================================================

# --- Media & Audio/Video ---
# cask "spotify"
# cask "vlc"
# cask "plex-htpc"
# cask "plex-media-server"
# cask "plexamp"
# cask "edde746/plezy/plezy"
# cask "audacity"
# cask "audiobook-builder"
# cask "handbrake-app"
# cask "makemkv"
# cask "mp3tag"
# cask "musicbrainz-picard"
# cask "screenflow"
# cask "4k-youtube-to-mp3"
# cask "youtube-to-mp3"
# cask "send-to-kindle"
# cask "burn"
# cask "adobe-creative-cloud"

# --- Games & Streaming ---
# cask "steam"
# cask "endless-sky"
# cask "endless-sky-high-dpi"
# cask "godot"
# cask "moonlight"
# cask "parsec"

# --- Backup & Disk ---
# cask "carbon-copy-cloner"
# cask "superduper"
# cask "disk-drill"
# cask "drivedx"
# cask "balenaetcher"
# cask "timemachineeditor"
# cask "timemachinestatus"

# --- System / Hardware-specific ---
# cask "opencore-patcher"
# cask "switchresx"
# cask "logi-options+"
# cask "logitune"
# cask "android-platform-tools"
# cask "microsoft-auto-update"
# cask "geekbench"
# cask "windows-app"

# --- Sync & Misc ---
# cask "resilio-sync"
# cask "syncthing-app"
# cask "basecamp"
# cask "focus"
# cask "screenfocus"
# cask "xscope"
# cask "path-finder"
# cask "transmission"

# =============================================================================
# VS Code Extensions
# =============================================================================
vscode "anthropic.claude-code"
vscode "coderabbit.coderabbit-vscode"
vscode "dbaeumer.vscode-eslint"
vscode "docker.docker"
vscode "esbenp.prettier-vscode"
vscode "github.vscode-pull-request-github"
vscode "mblode.twig-language-2"
vscode "ms-azuretools.vscode-containers"
vscode "ms-azuretools.vscode-docker"
vscode "ms-vscode-remote.remote-containers"
vscode "prisma.prisma"

# =============================================================================
# Global npm packages
# =============================================================================
npm "@shopify/cli"

# =============================================================================
# Mac App Store Apps (requires: mas) — none currently installed
# =============================================================================
# mas "Xcode", id: 497799835
