# zsh.installer

An automated installer script for setting up Zsh with Oh-My-Zsh on iSH (iOS Shell) with seamless GitHub credential configuration.

## Overview

This script automates the complete setup of Zsh on iSH for mobile development, including:
- Installing Oh-My-Zsh with an elegant terminal UI
- Configuring Zsh as the default shell
- Setting up Git credential storage for seamless GitHub development
- Beautiful progress indicators and status updates

## Features

✅ **One-Command Installation** - Single command setup via `sh -c`  
✅ **Oh-My-Zsh Integration** - Automatic installation of Oh-My-Zsh framework  
✅ **Default Shell Configuration** - Automatically sets Zsh as your default shell  
✅ **Git Credential Helper** - Configures `credential.helper store` for password-free GitHub operations  
✅ **Beautiful Terminal UI** - ANSI color-coded progress indicators and status boxes  
✅ **Unattended Installation** - Minimal user interaction required  

## Prerequisites

- **iSH App** - iOS shell environment ([iSH on App Store](https://apps.apple.com/us/app/ish-shell/id1436902243))
- **Internet Connection** - Required for downloading packages and Oh-My-Zsh
- **Alpine Linux** - iSH runs Alpine Linux by default

## Installation

Run the following command in your iSH terminal:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/statikfintechllc/zsh.installer/master/master/install.sh)"
```

### Alternative: Download and Run

```sh
curl -fsSL https://raw.githubusercontent.com/statikfintechllc/zsh.installer/master/master/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

## What the Script Does

The installer performs the following steps:

### Step 0: Prerequisites
- Installs build dependencies: `build-base`, `ncurses-dev`, `git`, `zsh`
- Uses Alpine's `apk` package manager

### Step 1: Oh-My-Zsh Installation
- Downloads and installs Oh-My-Zsh framework
- Runs in unattended mode for automated setup

### Step 2: Default Shell Configuration
- Adds `exec zsh` to `~/.profile`
- Ensures Zsh launches automatically on login

### Step 3: Git Credential Setup
- Configures `git config --global credential.helper store`
- Prompts for GitHub credentials (stored securely for future use)
- Credentials are saved to `~/.git-credentials`

### Step 4: Completion
- Displays installation summary with status indicators
- Shows next steps for using Zsh

## Post-Installation

After installation completes:

1. **Restart iSH** - Close and reopen the iSH app to start using Zsh
2. **Customize Zsh** - Edit `~/.zshrc` to customize your shell experience
3. **GitHub Authentication** - Your Git credentials are now stored; future `git push/pull` operations won't require re-authentication

## Usage

Once installed, your iSH terminal will automatically launch Zsh with Oh-My-Zsh configured.

### Testing Git Integration

```sh
git clone https://github.com/yourusername/your-repo.git
cd your-repo
# Make changes
git add .
git commit -m "Update from iSH"
git push  # No password prompt!
```

## Troubleshooting

### Script Fails to Download
- Check your internet connection
- Verify GitHub is accessible from your network

### Build Dependencies Fail to Install
- Run `apk update` first
- Ensure sufficient storage space on your device

### Zsh Doesn't Launch After Restart
- Manually run: `source ~/.profile`
- Check if `~/.profile` contains `exec zsh`

### Git Credentials Not Saved
- Credentials are stored in `~/.git-credentials`
- Verify with: `cat ~/.git-credentials`
- Format: `https://username:token@github.com`

### Permission Denied Errors
- Ensure the script has execute permissions: `chmod +x install.sh`
- Check file ownership: `ls -la`

## Security Notes

⚠️ **Credential Storage**: This script uses `credential.helper store` which stores credentials in **plain text** in `~/.git-credentials`. For enhanced security, consider using a personal access token instead of your password.

To create a GitHub personal access token:
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token with appropriate permissions
3. Use the token as your password when prompted

## Customization

### Changing Oh-My-Zsh Theme

Edit `~/.zshrc`:
```sh
# Find the ZSH_THEME line and change it
ZSH_THEME="robbyrussell"  # Default
# Try: agnoster, powerlevel10k, spaceship, etc.
```

### Adding Plugins

Edit `~/.zshrc`:
```sh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is open source and available under the MIT License.

## Author

**statikfintechllc**

## Acknowledgments

- [Oh-My-Zsh](https://ohmyz.sh/) - Framework for managing Zsh configuration
- [iSH Project](https://ish.app/) - iOS shell environment
- Alpine Linux community

---

**Made with ❤️ for mobile developers**
