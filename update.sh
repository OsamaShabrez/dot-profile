#!/usr/bin/env zsh

REPO_DIR="$HOME/.dot-profile"
LAST_CHECK_FILE="$REPO_DIR/.last_update_check"
CHECK_INTERVAL=86400

# Protect against non-Git folders
[ ! -d "$REPO_DIR/.git" ] && return 0

CURRENT_TIME=$(date +%s)
LAST_CHECK=0
[ -f "$LAST_CHECK_FILE" ] && LAST_CHECK=$(cat "$LAST_CHECK_FILE")

# Verify if 24 hours have passed
if (( CURRENT_TIME - LAST_CHECK > CHECK_INTERVAL )); then
    
    # 1. Update the timestamp file immediately in the foreground.
    # This prevents duplicate network spawns if you open 5 tabs rapidly.
    date +%s > "$LAST_CHECK_FILE"

    # 2. Spawn a cleanly inherited background process
    {
        cd "$REPO_DIR" || exit
        
        # Pull updates quietly
        git fetch origin main >/dev/null 2>&1
        LOCAL=$(git rev-parse @ 2>/dev/null)
        REMOTE=$(git rev-parse @{u} 2>/dev/null)

        if [ -n "$LOCAL" ] && [ -n "$REMOTE" ] && [ "$LOCAL" != "$REMOTE" ]; then
            # Use absolute paths to output directly to your active tty
            exec </dev/null
            echo "\n\e[1;36m[dot-profile]\e[0m Updates detected on GitHub. Pulling changes..." > /dev/tty
            git pull origin main >/dev/null 2>&1
            echo "\e[1;32m[dot-profile]\e[0m Environment updated! Restart your shell to apply changes.\n" > /dev/tty
        fi
    } >/dev/null 2>&1 &!
fi
