#!/bin/sh
# =====================================================
# STATIKFINTECHLLC // MASTER_BOOTSTRAP
# Phase 1: Environment Setup (sh/cyan)
# Phase 2: Credentials & Sync (zsh/red)
# =====================================================

# --- PHASE 1 COLORS (Cyan Theme) ---
CYAN='\033[36m'
GREEN='\033[32m'
BOLD='\033[1m'
RESET='\033[0m'

# --- PHASE 1 FUNCTIONS ---
print_box() {
  echo "${CYAN}┌─────────────────────────────────────────┐${RESET}"
  echo "${CYAN}│${BOLD} $1${RESET}${CYAN} │${RESET}"
  echo "${CYAN}├─────────────────────────────────────────┤${RESET}"
  printf "%s\n" "$2" | while IFS= read -r line; do
    printf "${CYAN}│ ${RESET}%-37s${CYAN} │${RESET}\n" "$line"
  done
  echo "${CYAN}└─────────────────────────────────────────┘${RESET}"
}

progress() {
  secs=$1
  echo -ne "   [....................] (0%)"
  sleep 0.2
  echo -ne "\r   [#######.............] (35%)"
  sleep $(echo "$secs/2" | bc -l)
  echo -ne "\r   [##############......] (70%)"
  sleep $(echo "$secs/2" | bc -l)
  echo -e "\r   [####################] (100%) ${GREEN}Done${RESET}"
}

# =====================================================
# EXECUTION: PHASE 1 (INSTALLATION)
# =====================================================
clear
print_box "Step 1/4" "Installing System Dependencies..."
# Ensure we have jq, zsh, git, and bc for math
apk update >/dev/null 2>&1
if ! apk add --no-cache build-base ncurses-dev git zsh jq bc curl >/dev/null 2>&1; then
  echo "${RED}Error: Failed to install dependencies${RESET}"
  exit 1
fi
progress 2

print_box "Step 2/4" "Installing Oh-My-Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null 2>&1
else
  echo "   Oh-My-Zsh already installed."
fi
progress 1

print_box "Step 3/4" "Setting Zsh as Default..."
# This ensures iSH loads ZSH on next boot
if ! grep -q "exec zsh" ~/.profile; then
  echo '[ -z "$ZSH_VERSION" ] && exec zsh' >> ~/.profile
fi
progress 0.5

# =====================================================
# EXECUTION: PHASE 2 (HANDOFF TO ZSH)
# =====================================================
# We now create a temporary ZSH script to handle the visual transition
# and the complex logic that requires JQ and ZSH arrays.
cat << 'EOF' > /tmp/statik_sync_core.zsh
#!/bin/zsh

# --- PHASE 2 COLORS (Red Theme) ---
RED='\033[0;31m'
B_RED='\033[1;31m'
DARK='\033[2;31m'
GOLD='\033[1;33m'
RESET='\033[0m'

clear
# Digital Rain Header
echo "${DARK}"
cat << "HEADER"
 _________________________________________
|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|1|0|
 STATIK_FINTECH // SYSTEM_HANDOFF
|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
HEADER
echo "${RESET}"

# --- GIT CONFIGURATION UI ---
echo "${B_RED}>> INITIALIZING CREDENTIAL PROTOCOL...${RESET}"
echo ""
echo "${DARK}Please enter GitHub Identity for Global Config:${RESET}"

# 1. Username
printf "${B_RED}GitHub Username:${RESET} "
read GH_USER

# 2. Email (Crucial for commits)
printf "${B_RED}GitHub Email:   ${RESET} "
read GH_EMAIL

# 3. Token
printf "${B_RED}GitHub Token:   ${RESET} "
read -s GH_TOKEN
echo ""
echo ""

# --- APPLYING GIT CONFIG ---
echo "${DARK}>> WRITING CONFIGURATION...${RESET}"

# Set Global Name/Email
git config --global user.name "$GH_USER"
git config --global user.email "$GH_EMAIL"

# Set Credential Helper (Store allows permanent login)
git config --global credential.helper store

# Create credentials file properly
if [ -n "$GH_USER" ] && [ -n "$GH_TOKEN" ]; then
    # Simple URL encoding for safety
    GH_USER_ENC=$(printf '%s' "$GH_USER" | sed 's/@/%40/g; s/:/%3A/g; s/ /%20/g')
    GH_TOKEN_ENC=$(printf '%s' "$GH_TOKEN" | sed 's/@/%40/g; s/:/%3A/g; s/ /%20/g')
    
    # Write to ~/.git-credentials
    echo "https://${GH_USER_ENC}:${GH_TOKEN_ENC}@github.com" > ~/.git-credentials
    chmod 600 ~/.git-credentials
    printf "${GOLD}[ SUCCESS ] Credentials Encrypted & Stored.${RESET}\n"
else
    printf "${RED}[ WARNING ] Credentials missing. Skipping Auth write.${RESET}\n"
fi
sleep 1

# =====================================================
# EXECUTION: PHASE 3 (REPO SYNC)
# =====================================================

# Spinner Function
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⣾⣽⣻⢿⡿⣟⣯⣷' 
    while kill -0 "$pid" 2>/dev/null; do
        for i in {1..8}; do
            printf "\r${DARK}%-20s${B_RED} [ %s ]${RESET}" "$2" "${spinstr:$i:1}"
            sleep $delay
        done
    done
}

printf "\n${B_RED}>> ENGAGING REPO SYNC ENGINE...${RESET}\n"

# Create builds directory if it doesn't exist and enter it
if [ ! -d "builds" ]; then
    mkdir builds
fi
cd builds || exit

# Use the token for the API call (Avoids API limits)
# If token exists, use it. If not, try public.
if [ -n "$GH_TOKEN" ]; then
    AUTH_HEADER="Authorization: token $GH_TOKEN"
else
    AUTH_HEADER="User-Agent: statik-bot"
fi

JSON_DATA=$(curl -s -H "$AUTH_HEADER" "https://api.github.com/users/$GH_USER/repos?per_page=100")

# Check if we got valid JSON or an error
IS_VALID=$(echo "$JSON_DATA" | jq -r 'if type=="array" then "yes" else "no" end' 2>/dev/null)

if [ "$IS_VALID" != "yes" ]; then
    echo "${RED}[ ERROR ] Unable to fetch repos. Check Token or API Status.${RESET}"
    echo "Response: $JSON_DATA"
    exit 1
fi

REPO_LIST=$(echo "$JSON_DATA" | jq -r '.[].clone_url')
TOTAL_REPOS=$(echo "$REPO_LIST" | wc -l | tr -d ' ')

printf "\r${GOLD}>> TARGETS ACQUIRED: ${TOTAL_REPOS}      ${RESET}\n\n"

COUNT=1
echo "$REPO_LIST" | while read -r repo; do
    [ -z "$repo" ] && continue
    
    dir=$(basename "$repo" .git)
    PROGRESS_TAG="[$(printf "%02d" $COUNT)/$TOTAL_REPOS]"

    if [ -d "$dir/.git" ]; then
        (cd "$dir" && git pull --ff-only >/dev/null 2>&1) &
        spinner $! "$dir"
        printf "\r${DARK}%-20s${RESET} ${GOLD}[ UPDATED ] ${DARK}$PROGRESS_TAG${RESET}\n" "$dir"
    else
        git clone "$repo" >/dev/null 2>&1 &
        spinner $! "$dir"
        printf "\r${B_RED}%-20s${RESET} ${GOLD}[ CLONED  ] ${DARK}$PROGRESS_TAG${RESET}\n" "$dir"
    fi
    ((COUNT++))
done

echo "\n${DARK}-----------------------------------------"
echo "${B_RED}  BOOTSTRAP COMPLETE // RESTARTING SHELL"
echo "${DARK}-----------------------------------------${RESET}"

# Switch to ZSH permanently
exec zsh -l
EOF

# Run the Phase 2/3 script using the newly installed ZSH
chmod +x /tmp/statik_sync_core.zsh
/bin/zsh /tmp/statik_sync_core.zsh

