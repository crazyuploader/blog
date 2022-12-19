#!/usr/bin/env bash

# Colors
NC="\033[0m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Variables
HUGO_VERSION="0.108.0"

# Installing Hugo
echo ""
echo -e "${YELLOW}Installing Hugo Site Generator${NC}"
curl -sLo hugo.deb https://github.com/gohugoio/hugo/releases/download/v"${HUGO_VERSION}"/hugo_"${HUGO_VERSION}"_linux-amd64.deb
sudo dpkg -i hugo.deb
rm -rf hugo.deb
echo ""
echo -e "${GREEN}Done!${NC}"

# Cloning modified theme
echo ""
echo -e "${YELLOW}Cloning modified version of Hugo Theme${NC}"
git clone https://github.com/rhazdon/hugo-theme-hello-friend-ng themes/hello-friend-ng
echo ""
echo -e "${GREEN}Done!${NC}"

# Building site
echo ""
echo -e "${YELLOW}Getting current build copy of the site${NC}"
git clone https://"${GITHUB_REF}" -b master ~/public
echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo -e "${YELLOW}Building site with Hugo${NC}"
hugo -d ~/public
cd ~/public || exit 1

# Remove School if present
if [[ -d "school" ]]; then
    rm -rf school
fi

# Pushing built to GitHub
git config user.email "49350241+crazyuploader@users.noreply.github.com"
git config user.name "crazyuploader"
echo ""
git status
git add .
git commit -m "CI Auto Site Builder [ci skip]"
echo ""
echo -e "${YELLOW}Pushing built site to GitHub${NC}"
git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GITHUB_REF}" HEAD:master
echo ""
echo -e "${GREEN}Done${NC}"
