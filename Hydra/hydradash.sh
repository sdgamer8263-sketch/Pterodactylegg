#!/bin/bash

# ASCII Art
ascii_art="
  _____ _____   _____          __  __ ______ _____  
 / ____|  __ \ / ____|   /\   |  \/  |  ____|  __ \ 
| (___ | |  | | |  __   /  \  | \  / | |__  | |__) |
 \___ \| |  | | | |_ | / /\ \ | |\/| |  __| |  _  / 
 ____) | |__| | |__| |/ ____ \| |  | | |____| | \ \ 
|_____/|_____/ \_____/_/    \_\_|  |_|______|_|  \_\
"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Clear the screen
clear

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root.${NC}"
  exit 1
fi

echo -e "${CYAN}$ascii_art${NC}"

# ---------------------------------------------------------
# STEP 1: ASK FOR SUBDOMAIN (User Input)
# ---------------------------------------------------------
echo -e "${YELLOW}Enter your Subdomain (e.g., panel.yourdomain.com):${NC}"
read -p "Subdomain: " USER_DOMAIN

if [ -z "$USER_DOMAIN" ]; then
  echo -e "${RED}Error: No subdomain entered. Exiting...${NC}"
  exit 1
fi

echo -e "${GREEN}Domain set to: $USER_DOMAIN${NC}"
echo -e "${BLUE}Starting installation in 3 seconds...${NC}"
sleep 3

# ---------------------------------------------------------
# STEP 2: INSTALL DEPENDENCIES
# ---------------------------------------------------------
echo -e "${YELLOW}* Installing Dependencies${NC}"

# Update package list and install dependencies
sudo apt update
sudo apt install -y curl software-properties-common git

# Install Node.js 20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install nodejs -y 

echo -e "${GREEN}* Installed Dependencies${NC}"

# ---------------------------------------------------------
# STEP 3: CLONE AND INSTALL PANEL
# ---------------------------------------------------------
echo -e "${YELLOW}* Installing Skyport Files${NC}"

# Clone repository
if [ -d "oversee-fixed" ]; then
  echo -e "${RED}Directory 'oversee-fixed' already exists. Deleting it to reinstall...${NC}"
  rm -rf oversee-fixed
fi

git clone https://github.com/draco-labes/oversee-fixed.git
cd oversee-fixed || exit

# Install NPM packages
echo -e "${BLUE}* Running npm install...${NC}"
npm install

# Seed Database
echo -e "${BLUE}* Seeding Database...${NC}"
npm run seed

# Create User
echo -e "${BLUE}* Creating User...${NC}"
npm run createUser

# ---------------------------------------------------------
# STEP 4: START SERVER
# ---------------------------------------------------------
echo -e "${GREEN}* Installation Complete!${NC}"
echo -e "${YELLOW}Your panel is configured for: $USER_DOMAIN${NC}"
echo -e "${CYAN}* Starting Skyport on Port 3001...${NC}"

# Start the node application
node .
