# dot-profile - Shell Configurations & Dotfiles

This repository hosts personal shell configurations, custom functions, command aliases, and utility scripts to maintain a consistent terminal environment across machines. 

## Installation & Setup

To use these configurations, clone this repository directly into your home directory (`~`). It must be named `.dot-profile`.

```bash
git clone git@github.com:OsamaShabrez/dot-profile.git ~/.dot-profile
```

### Integration with Zsh / Bash

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
