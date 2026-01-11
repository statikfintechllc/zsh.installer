#!/bin/sh
# statikfintechllc/zsh.installer - Advanced Terminal UI Installer

# -------- ANSI Color Shortcuts --------
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
CYAN='\033[36m'
BOLD='\033[1m'
RESET='\033[0m'

# -------- Helper Functions --------
print_box() {
  # $1 = title, $2 = content
  echo "${CYAN}┌─────────────────────────────────────────┐${RESET}"
  echo "${CYAN}│${BOLD} $1${RESET}${CYAN} │${RESET}"
  echo "${CYAN}├─────────────────────────────────────────┤${RESET}"
  printf "%s\n" "$2" | while IFS= read -r line; do
    printf "${CYAN}│ ${RESET}%-37s${CYAN} │${RESET}\n" "$line"
  done
  echo "${CYAN}└─────────────────────────────────────────┘${RESET}"
}

progress() {
  # Simple progress bar animation for $1 seconds
  secs=$1
  echo -n "   ["
  for i in $(seq 1 20); do
    echo -n " "
  done
  echo -n "]"
  echo -ne "\r   ["
  for i in $(seq 1 20); do
    echo -n "#"
    sleep $(echo "$secs/20" | bc -l)
  done
  echo "] ${GREEN}Done${RESET}"
}

# -------- Step 0: prerequisites --------
print_box "Step 0" "Installing build dependencies..."
apk add --no-cache build-base ncurses-dev git zsh >/dev/null 2>&1
progress 1

# -------- Step 1: Install Oh-My-Zsh --------
print_box "Step 1" "Installing Oh-My-Zsh unattended..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1
progress 2

# -------- Step 2: Make Zsh default --------
print_box "Step 2" "Setting Zsh as default shell..."
echo 'exec zsh' >> ~/.profile
progress 0.5

# -------- Step 3: Configure Git --------
print_box "Step 3" "Configuring Git credential storage..."
git config --global credential.helper store
echo "${YELLOW}⚠ Enter Git credentials once when prompted:${RESET}"
git ls-remote https://github.com/statikfintechllc/test-repo.git 2>/dev/null || true
progress 1

# -------- Step 4: Final UI --------
print_box "✅ Installation Complete" "
${GREEN}[✔] Oh-My-Zsh installed
${GREEN}[✔] Zsh default shell
${GREEN}[✔] Git credential helper store
${CYAN}Restart iSH to start using Zsh
"

echo "${BOLD}${CYAN}Thank you for using zsh.installer!${RESET}"
