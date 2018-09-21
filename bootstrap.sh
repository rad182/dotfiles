#!/usr/bin/env bash

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo "installing homebrew"
# install homebrew https://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "brew installing stuff"
brew analytics off
brew update
brew upgrade --all
brew bundle --verbose
brew cleanup

echo "installing powerline via pip"
sudo easy_install pip
sudo pip install powerline-shell

echo "linking dotfiles"
ln -s "${PWD}/bin" "${HOME}/.bin"
ln -s "${PWD}/.aliases" "${HOME}/"
ln -s "${PWD}/.exports" "${HOME}/.exports"
ln -s "${PWD}/.bash_profile" "${HOME}/.bash_profile"
ln -s "${PWD}/.bash_prompt" "${HOME}/.bash_prompt"
ln -s "${PWD}/.gitignore_global" "${HOME}/.gitignore_global"
ln -s "${PWD}/.gitconfig" "${HOME}/.gitconfig"
ln -s "${PWD}/.gitattributes" "${HOME}/.gitattributes"
ln -s "${PWD}/.editorconfig" "${HOME}/.editorconfig"
ln -s "${PWD}/.functions" "${HOME}/.functions"
ln -s "${PWD}/.gemrc" "${HOME}/.gemrc"
ln -s "${PWD}/.inputrc" "${HOME}/.inputrc"
ln -s "${PWD}/.wgetrc" "${HOME}/.wgetrc"
ln -s "${PWD}/.axelrc" "${HOME}/.axelrc"
ln -s "${PWD}/.lldbinit" "${HOME}/.lldbinit"
ln -s "${PWD}/.hushlogin" "${HOME}/.hushlogin"
ln -s "${PWD}/.hyper.js" "${HOME}/.hyper.js"

echo "installing node (via n-install)"
curl -L https://git.io/n-install | bash

echo "node --version: $(node --version)"
echo "npm --version: $(npm --version)"

# https://github.com/yarnpkg/yarn/issues/1116#issuecomment-354363271
brew install yarn --without-node

echo "installing gems"
# install bundler gem
gem install bundler
# install all gems from the Gemfile
bundle install
