#!/usr/bin/env bash

# Installing Hugo
curl -sLo hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.71.0/hugo_0.71.0_Linux-64bit.deb
sudo dpkg -i hugo.deb
rm -rf hugo.deb

# Cloning modified theme
git clone https://github.com/crazyuploader/modified-hugo-theme themes/modified-hugo-theme

# Building site
git clone https://"${GITHUB_REF}" -b master ~/public
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
git commit -m "Travis CI Auto Site Builder"
git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GITHUB_REF}" HEAD:master
echo ""
echo "Done"
