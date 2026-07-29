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
