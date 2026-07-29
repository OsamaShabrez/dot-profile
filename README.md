# dot-profile - Shell Configurations & Dotfiles

This repository hosts personal shell configurations, custom functions, command aliases, and utility scripts to maintain a consistent terminal environment across machines. 

## Installation & Setup

To use these configurations, clone this repository directly into your home directory (`~`). It must be named `.dot-profile`.

```bash
git clone git@github.com:OsamaShabrez/dot-profile.git ~/.dot-profile
```

### 1. Install Dependencies

The interactive mode of the `gitr` branch cleanup tool requires `fzf` (Command-line fuzzy finder). Install it using your system's package manager:

* **macOS (Homebrew):**
  ```bash
  brew install fzf
  ```
* **Ubuntu / Debian:**
  ```bash
  sudo apt update && sudo apt install fzf
  ```
* **Fedora / RHEL:**
  ```bash
  sudo dnf install fzf
  ```

### 2. Integration with Zsh / Bash

To automatically load all configurations and scripts from this repository, add the following code snippet to your main initialization file (e.g., `~/.zshrc` or `~/.bashrc`):

```sh
if [ -d "\$HOME/.dot-profile" ]; then
    for file in "\$HOME"/.dot-profile/*.sh; do
        [ -r "\(file" ] && source "\)file"
    done
fi
```

*Note: The snippet ensures that every valid `.sh` file inside the repository is securely verified and sourced upon opening a new shell session.*

## Repository Structure & Purpose

* **Aliases:** Streamlined shortcuts for everyday terminal commands.
* **Functions:** Multi-step shell automations and workflows.
* **Scripts:** Independent executable utilities for environment management.

## Security Guidelines

This is a public-ready configuration repository. **Do not commit sensitive data.**

* **No Secrets:** Never commit API keys, private ssh keys, or sensitive environment variables.
* **Strict Ignoring:** Any file prefixed with `private-*` is automatically blocked by the `.gitignore` configuration.
* **Manual Management:** Transfer system-specific credentials and environment files (`.env`) manually to destination machines when and where required.

## Feature Spotlight: `gitr` (Git Branch Cleanup)

The repository includes `gitr`, a specialized Zsh utility designed to safely batch-delete stale local Git branches. It supports dry-runs, precise filtering, and terminal-based interactive selection.

### Core Features

* **Automated Whitelisting:** Automatically protects the active working branch, `main`, `master`, and `develop` from accidental deletion.
* **Smart Filtering:** Matches case-insensitive substrings to filter out branches you want to keep before executing actions.
* **Interactive UI:** Interfaces seamlessly with `fzf` to let you visually select branches with a live, 30-commit graphical preview window.

### Usage & Syntax

```bash
gitr <action> [flags] [filters...]
```

#### Actions
* **`gitr list [filters...]`**: (Default) Runs a dry-run. Lists all target candidates that would be queued for deletion without executing any changes.
* **`gitr delete [filters...]`**: Triggers a sequential prompt to delete target branches. Uses standard unmerged checks (`git branch -d`).
* **`gitr interactive [filters...]`**: Launches the `fzf` interactive interface for custom selection.

#### Flags
* **`-f` / `--force`**: Replaces the deletion engine with `git branch -D`, forcing the removal of unmerged or stale branches. Requires an explicit visual confirmation prompt.

### Command Examples

```bash
# Preview all branches eligible for deletion
gitr list

# Preview branches, but ignore any containing "client" or "feature"
gitr list client feature

# Interactively pick branches to delete using a live commit graph preview
gitr interactive

# Force-delete unmerged branches matching criteria after interactive confirmation
gitr delete --force
```
