#!/bin/bash

# Colors for a clean look
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# 1) Clone the repository
echo -e "${CYAN}* Cloning HydraDAEMON repository...${NC}"
git clone https://github.com/hydren-dev/HydraDAEMON

# 2) Go into the directory
echo -e "${CYAN}* Entering HydraDAEMON directory...${NC}"
cd HydraDAEMON || exit

# 3) Install NPM dependencies
echo -e "${CYAN}* Installing NPM dependencies...${NC}"
npm install

echo -e "${GREEN}* Dependencies installed successfully!${NC}"

# 4) Echo the configure message and pause
echo ""
echo -e "${YELLOW}====================================================${NC}"
echo -e "${GREEN}Step 4: Paste your configure of node.${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo -e "Please open your configuration file (like config.json) in another"
echo -e "terminal tab, or paste your command to configure the node now."
echo ""

# This line pauses the script until you press Enter
read -p "Press [Enter] when you are done pasting your config to continue..."

# 5) Run the node app
echo ""
echo -e "${CYAN}* Starting HydraDAEMON...${NC}"
node .
