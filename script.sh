#!/usr/bin/env bash

# Installing Hugo
curl -sLo hugo.deb https://github.com/gohugoio/hugo/releases/download/v0.71.0/hugo_0.71.0_Linux-64bit.deb
sudo dpkg -i hugo.deb
rm -rf hugo.deb

# Building site
git clone https://"${GITHUB_REF}" -b master ~/public
hugo -d ~/public
cd ~/public

# Pushing built to GitHub
git config user.email "49350241+crazyuploader@users.noreply.github.com"
git config user.name "crazyuploader"
echo ""
git add .
git commit -m "Travis CI Auto Site Builder"
git push https://crazyuploader:"${GITHUB_TOKEN}"@"${GITHUB_REF}" HEAD:master
echo ""
echo "Done"
