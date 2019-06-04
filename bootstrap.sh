#!/usr/bin/env bash

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

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
ln -s "${PWD}/.zshrc" "${HOME}/.zshrc"
ln -s "${PWD}/.gitignore_global" "${HOME}/.gitignore_global"
ln -s "${PWD}/.gitconfig" "${HOME}/.gitconfig"
ln -s "${PWD}/.gitattributes" "${HOME}/.gitattributes"
ln -s "${PWD}/.editorconfig" "${HOME}/.editorconfig"
ln -s "${PWD}/.gemrc" "${HOME}/.gemrc"
ln -s "${PWD}/.inputrc" "${HOME}/.inputrc"
ln -s "${PWD}/.wgetrc" "${HOME}/.wgetrc"
ln -s "${PWD}/.axelrc" "${HOME}/.axelrc"
ln -s "${PWD}/.hushlogin" "${HOME}/.hushlogin"
ln -s "${PWD}/.hyper.js" "${HOME}/.hyper.js"
ln -s "${PWD}/powerline-shell" "${HOME}/.config/"

echo "installing node (via n-install)"
curl -L https://git.io/n-install | bash
. ${HOME}/.bash_profile

echo "node --version: $(node --version)"
echo "npm --version: $(npm --version)"

# https://github.com/yarnpkg/yarn/issues/1116#issuecomment-354363271
brew install yarn --without-node

# Install rbenv
echo "installing rbenv"
brew install rbenv
rbenv init
echo "installing latest stable ruby"
RUBY_VERSION=$(rbenv install -l | grep -v - | tail -1)
rbenv install $RUBY_VERSION
rbenv global $RUBY_VERSION
rbenv rehash

echo "installing gems"
# install bundler gem
gem install bundler
# install all gems from the Gemfile
bundle install
