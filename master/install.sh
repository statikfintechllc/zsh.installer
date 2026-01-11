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
  # Note: Content is formatted to fit within 37 characters per line
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
if ! apk add --no-cache build-base ncurses-dev git zsh bc >/dev/null 2>&1; then
  echo "${RED}Error: Failed to install dependencies${RESET}"
  exit 1
fi
progress 1

# -------- Step 1: Install Oh-My-Zsh --------
print_box "Step 1" "Installing Oh-My-Zsh unattended..."
if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1; then
  echo "${RED}Error: Failed to install Oh-My-Zsh${RESET}"
  exit 1
fi
progress 2

# -------- Step 2: Make Zsh default --------
print_box "Step 2" "Setting Zsh as default shell..."
echo '[ -z "$ZSH_VERSION" ] && exec zsh' >> ~/.profile
progress 0.5

# -------- Step 3: Configure Git --------
print_box "Step 3" "Configuring Git credential storage..."
git config --global credential.helper store

# Collect GitHub credentials from user with UI
echo ""
echo "${CYAN}╔═══════════════════════════════════════════╗${RESET}"
echo "${CYAN}║${BOLD}  GitHub Credential Setup                ${RESET}${CYAN}║${RESET}"
echo "${CYAN}╠═══════════════════════════════════════════╣${RESET}"
echo "${CYAN}║${RESET}  Enter your GitHub username and token  ${CYAN}║${RESET}"
echo "${CYAN}║${RESET}  (Credentials stored in plain text)    ${CYAN}║${RESET}"
echo "${CYAN}╚═══════════════════════════════════════════╝${RESET}"
echo ""

# Prompt for GitHub username
printf "${BOLD}${CYAN}GitHub Username:${RESET} "
read -r GH_USERNAME

# Prompt for GitHub token/password
printf "${BOLD}${CYAN}GitHub Token/Password:${RESET} "
read -rs GH_TOKEN
echo ""

# Store credentials in ~/.git-credentials file
if [ -n "$GH_USERNAME" ] && [ -n "$GH_TOKEN" ]; then
  # URL encode the credentials (basic validation and encoding for special chars)
  GH_USERNAME_ENC=$(printf '%s' "$GH_USERNAME" | sed 's/@/%40/g; s/:/%3A/g; s/ /%20/g')
  GH_TOKEN_ENC=$(printf '%s' "$GH_TOKEN" | sed 's/@/%40/g; s/:/%3A/g; s/ /%20/g')
  echo "https://${GH_USERNAME_ENC}:${GH_TOKEN_ENC}@github.com" > ~/.git-credentials
  chmod 600 ~/.git-credentials
  echo "${GREEN}✓ Credentials saved successfully${RESET}"
else
  echo "${YELLOW}⚠ Skipped: No credentials entered${RESET}"
fi

progress 1

# -------- Step 4: Final UI --------
print_box "✅ Installation Complete" "
${GREEN}[✔] Oh-My-Zsh installed
${GREEN}[✔] Zsh default shell
${GREEN}[✔] Git credential helper store
${CYAN}Restart iSH to start using Zsh
"

echo "${BOLD}${CYAN}Thank you for using zsh.installer!${RESET}"
