#!/usr/bin/env bash

# Colors
NC="\033[0m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"

# Variables
HUGO_VERSION="0.74.2"

# Installing Hugo
echo ""
echo -e "${YELLOW}Installing Hugo Site Generator${NC}"
curl -sLo hugo.deb https://github.com/gohugoio/hugo/releases/download/v"${HUGO_VERSION}"/hugo_"${HUGO_VERSION}"_Linux-64bit.deb
sudo dpkg -i hugo.deb
rm -rf hugo.deb
echo ""
echo -e "${GREEN}Done!${NC}"

# Cloning modified theme
echo ""
echo -e "${YELLOW}Cloning modified version of Hugo Theme${NC}"
git clone https://github.com/crazyuploader/modified-hugo-theme themes/modified-hugo-theme
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

# Custom Function to get school website project
function GET_SCHOOL() {
    rm -rf school/
    cd /tmp || exit 1
    curl -sLo school.zip https://github.com/crazyuploader/school/archive/master.zip
    unzip -d temp/ school.zip 1> /dev/null
    rm -rf school.zip
    cd temp || exit 1
    mv school-master/ school/
    mv school/ ~/public
    cd ~/public || exit 1
}

# Pushing built to GitHub
git config user.email "49350241+crazyuploader@users.noreply.github.com"
git config user.name "crazyuploader"
GET_SCHOOL
echo ""
git status
git add .
git commit -m "CI Auto Site Builder [ci skip]"
echo ""
echo -e "${YELLOW}Pushing built site to GitHub${NC}"
git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GITHUB_REF}" HEAD:master
echo ""
echo -e "${GREEN}Done${NC}"
