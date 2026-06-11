# -----------------------------------------------------------------------------
# Aliases — General
# -----------------------------------------------------------------------------

alias reload="source ~/.zshrc"
alias c='clear'
alias h='history'
alias path='echo $PATH | tr ":" "\n"'

# File listing
alias lsa='ls -lha | more'
alias ll='ls -la'

# Safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Networking
alias dnsflush="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# SSH
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'Copied to clipboard.'"

# Utilities
alias killcam='sudo killall VDCAssistant'
alias rs='rsync -ah --info=progress2'
alias python='python3'

# -----------------------------------------------------------------------------
# Aliases — Applications
# -----------------------------------------------------------------------------

alias slime='open -a "Sublime Text"'

# -----------------------------------------------------------------------------
# Aliases — tmux
# -----------------------------------------------------------------------------

alias tm="tmux"
alias tml="tmux list-sessions"
alias tma="tmux attach -t"

# -----------------------------------------------------------------------------
# Aliases — Git
# -----------------------------------------------------------------------------

alias g='git'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'

# -----------------------------------------------------------------------------
# Aliases — DDEV / Docker / CraftCMS
# -----------------------------------------------------------------------------

alias dd='ddev'
alias ddci='ddev composer install'
alias ddcu='ddev composer update'
alias ddc='ddev craft'
alias ddpca='ddev craft project-config/apply'
alias ddpct='ddev craft project-config/touch'
alias ddcma='ddev craft migrate/all'
alias ddsql='ddev sequelace'
alias ddnpmi='ddev npm install'
alias ddnpmu='ddev npm update'
alias ddstart='ddev start && ddev npm run dev'
alias ddyi='ddev yarn install'
alias ddyw='ddev yarn watch'

# CraftCMS (non-DDEV)
alias craft='./craft'
alias craftpca="./craft project-config/apply"
alias craftpct="./craft project-config/touch"
alias craftup="./craft upgrade"
alias craftupa="./craft update all"

# -----------------------------------------------------------------------------
# Aliases — Directories
# -----------------------------------------------------------------------------

alias sites="cd ~/Sites/"
alias sitesp="cd ~/Sites/Personal/"
alias sitesps="cd ~/Sites/PrettySquares/"
alias dotfiles='cd ~/.dotfiles'
