#!/usr/bin/env bash
# Description: Everyday shortcuts for developers and advanced terminal users.

# ------------------------------------------------------------------------------
# 📂 Navigation & Core Directory Commands
# ------------------------------------------------------------------------------
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias -- -----="cd -" # Toggle back to the last directory you were in

# ------------------------------------------------------------------------------
# 🔍 Enhanced File Listing (Colorized, Human-Readable, Sorted)
# ------------------------------------------------------------------------------
# Cross-platform color safety (detects whether to use GNU or BSD color flags)
if ls --color=auto >/dev/null 2>&1; then
  alias ls="ls --color=auto"
else
  alias ls="ls -G"
fi
alias ll="ls -lAh"                              # Detailed list including hidden files
alias l="ls -lh"                                # Detailed clean list
alias ldot="ls -ld .*"                          # List only hidden files/folders

# ------------------------------------------------------------------------------
# 💻 Modern Utility Upgrades & Overrides
# ------------------------------------------------------------------------------
alias grep="grep --color=auto"              # Always highlight search matches
alias df="df -h"                            # Disk free space in human units (GB/MB)
alias du="du -sh"                           # Calculate single directory size quickly
alias mkdir="mkdir -p"                      # Create recursive parent directories instantly
alias cp="cp -iv"                           # Interactive copy (asks before overwrite) + verbose
alias mv="mv -iv"                           # Interactive move (asks before overwrite) + verbose
alias rm="rm -iv"                           # Safe remove (asks before deletion) + verbose

# ------------------------------------------------------------------------------
# 🐙 Git Essentials
# ------------------------------------------------------------------------------
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit --amend --no-edit"
alias gp="git push"
alias gpf="git push --force-with-lease"      # Safe force push
alias gl="git pull"
alias gb="git branch"
alias gco="git checkout"
alias gd="git diff"
alias glg="git log --oneline --graph --decorate" # Clean visual tree history

alias gitc="git cz"
alias gitm='git checkout main && git pull --ff-only'

# ------------------------------------------------------------------------------
# 🐳 Docker Shortcuts
# ------------------------------------------------------------------------------
alias d="docker"
alias dc="docker compose"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'" # Compact layout
alias dlog="docker logs -f"
alias dclean="docker system prune -f --volumes" # Nukes unused container cache

# ------------------------------------------------------------------------------
# ⚡ System / Productivity Quality of Life
# ------------------------------------------------------------------------------
alias c="clear"
alias h="history"
alias ports="netstat -tulanp 2>/dev/null || lsof -i -P -n | grep LISTEN" # Active listen ports
alias myip="curl -s https://ifconfig.me && echo"                         # Public IP check
