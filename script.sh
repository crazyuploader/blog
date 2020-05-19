#!/usr/bin/env bash

# Installing Hugo
curl -sLo hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.71.0/hugo_0.71.0_Linux-64bit.deb
sudo dpkg -i hugo.deb
rm -rf hugo.deb

# Building site
git clone https://"${GITHUB_REF}" -b master ~/public
hugo -d ~/public
cd ~/public || exit 1

# Custom Function to get school website project
function GET_SCHOOL() {
    cd /tmp || exit 1
    curl -sLo school.zip https://github.com/crazyuploader/school/archive/master.zip
    unzip -d temp/ school.zip
    rm -rf school.zip
    cd temp || exit 1
    mv school-master school
    cd ..
    mv school/ ~/public
    cd ~/public || exit 1
}

# Pushing built to GitHub
git config user.email "49350241+crazyuploader@users.noreply.github.com"
git config user.name "crazyuploader"
GET_SCHOOL
echo ""
git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GITHUB_REF}" HEAD:master
echo ""
echo "Done"
