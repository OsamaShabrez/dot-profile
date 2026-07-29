# ==============================================================================
# File: completions.sh (Shell Completions & Plugins)
# ==============================================================================

# 1. Target Shell Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-completions
)

# 2. Append Third-Party Autocomplete Engine Directories
fpath+=/opt/homebrew/share/zsh-completions
fpath=(/Users/osamashabrez/.docker/completions $fpath)

# 3. Initialize and Cache Core Zsh Completions Engine
autoload -Uz compinit && compinit
