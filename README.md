# zsh.installer

An automated installer script for setting up Zsh with Oh-My-Zsh on iSH (iOS Shell) with seamless GitHub credential configuration.

## Installation

Run the following command in your iSH terminal:
```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/statikfintechllc/zsh.installer/master/master/ish.zsh.installer)"
```

## Overview

This script automates the complete setup of Zsh on iSH for mobile development, including:
- Installing Oh-My-Zsh with an elegant terminal UI
- Configuring Zsh as the default shell
- Setting up Git credential storage for seamless GitHub development
- Beautiful progress indicators and status updates

## Visual Gallery 🖼️

A quick visual guide to the installer's UI and progress. Click any thumbnail to jump to a larger view with descriptions. For a richer interactive experience (carousel, keyboard navigation, and big-square viewer), open the interactive gallery in your browser: `zsh.installer/gallery.html` (serve the repo locally with `python -m http.server` and visit `http://localhost:8000/zsh.installer/gallery.html`).

<div id="gallery" align="center">
<table>
<tr>
<td align="center">
<a href="#viewer-phase-1"><img src="example.img/Phase_1.jpeg" alt="Phase 1" width="180" /></a><br/>
**Phase 1**<br/><small>Installer start & initial prompts</small>
</td>
<td align="center">
<a href="#viewer-phase-2"><img src="example.img/Phase_2.jpeg" alt="Phase 2" width="180" /></a><br/>
**Phase 2**<br/><small>Progress indicators & configuration</small>
</td>
<td align="center">
<a href="#viewer-phase-3"><img src="example.img/Phase_3.jpeg" alt="Phase 3" width="180" /></a><br/>
**Phase 3**<br/><small>Completion & success message</small>
</td>
</tr>
</table>
</div>

### Viewer

<a id="viewer-phase-1"></a>
#### Phase 1 — Installer start
![Phase 1](example.img/Phase_1.jpeg)
**Description:** Installer initial screen with setup prompts and progress UI.  
[← Prev](#viewer-phase-3) | [Back to gallery](#gallery) | [Next →](#viewer-phase-2)

---

<a id="viewer-phase-2"></a>
#### Phase 2 — In-progress
![Phase 2](example.img/Phase_2.jpeg)
**Description:** Shows progress indicators and configuration steps in action.  
[← Prev](#viewer-phase-1) | [Back to gallery](#gallery) | [Next →](#viewer-phase-3)

---

<a id="viewer-phase-3"></a>
#### Phase 3 — Completion
![Phase 3](example.img/Phase_3.jpeg)
**Description:** Final success message and next steps after installation.  
[← Prev](#viewer-phase-2) | [Back to gallery](#gallery) | [Next →](#viewer-phase-1)

---

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

## What the Script Does

The installer performs the following steps:

### Step 0: Prerequisites
- Installs build dependencies: `build-base`, `ncurses-dev`, `git`, `zsh`, `bc`, `jq`
- Uses Alpine's `apk` package manager

### Step 1: Oh-My-Zsh Installation
- Downloads and installs Oh-My-Zsh framework
- Runs in unattended mode for automated setup

### Step 2: Default Shell Configuration
- Adds conditional `exec zsh` to `~/.profile` (avoids nested shells)
- Ensures Zsh launches automatically on login

### Step 3: Git Credential Setup
- Configures `git config --global credential.helper store`
- Interactive UI prompts for GitHub username and token/password
- Credentials are saved to `~/.git-credentials` in plain text
- File permissions set to 600 (owner read/write only)

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

⚠️ **Remote Script Execution**: This installer downloads and executes scripts from the internet (including Oh-My-Zsh installation from the mutable `master` branch). Always review scripts before running them with `sh -c "$(curl ..."` commands. If the upstream repository, GitHub account, or network path is compromised, an attacker could serve arbitrary shell commands. To reduce supply-chain risk, consider reviewing the script source code before execution.

⚠️ **Credential Storage**: This script uses `credential.helper store` which stores credentials in **plain text** in `~/.git-credentials`. This applies to both passwords and GitHub personal access tokens (PATs)—if you use a PAT, it will also be written to this plain-text file.

For maximum security on a shared or untrusted device, avoid using `credential.helper store` entirely. Instead, enter credentials manually when prompted, or use a more secure credential helper if one is available in your iSH/Alpine environment.

**Alternative credential helpers:**
- `git config --global credential.helper cache` - Stores credentials in memory for 15 minutes (more secure, but temporary)
- `git config --global credential.helper 'cache --timeout=3600'` - Cache for 1 hour

To create a GitHub personal access token:
1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Generate new token with appropriate permissions
3. Use the token as your password when prompted by the installer

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
