# ==============================================================================
# File: env.sh (System Paths, Environments & Tool Chains)
# ==============================================================================

# 1. Core System Path Exports (Ordered from lowest to highest priority)
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="$PATH:$(go env GOPATH)/bin"

# 2. Compiler Flags
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

# 3. Security & Terminal Environment Variables
export GPG_TTY=$(tty)
export ZSH_DISABLE_COMPFIX="true"

# 4. Node Version Manager Initialization (fnm)
eval "$(fnm env --use-on-cd --shell zsh)"

# 5. Set Global NPM configuration
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
