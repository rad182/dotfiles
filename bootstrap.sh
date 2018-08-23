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
brew linkapps
brew cleanup
brew cask cleanup

echo "installing powerline via pip"
sudo pip install powerline-shell

echo "linking dotfiles"
ln -s "bin" "${HOME}/.bin"
ln -s ".aliases" "${HOME}/.aliases"
ln -s ".exports" "${HOME}/.exports"
ln -s ".bash_profile" "${HOME}/.bash_profile"
ln -s ".bash_prompt" "${HOME}/.bash_prompt"
ln -s ".gitignore_global" "${HOME}/.gitignore_global"
ln -s ".gitconfig" "${HOME}/.gitconfig"
ln -s ".gitattributes" "${HOME}/.gitattributes"
ln -s ".editorconfig" "${HOME}/.editorconfig"
ln -s ".functions" "${HOME}/.functions"
ln -s ".gemrc" "${HOME}/.gemrc"
ln -s ".inputrc" "${HOME}/.inputrc"
ln -s ".wgetrc" "${HOME}/.wgetrc"
ln -s ".axelrc" "${HOME}/.axelrc"
ln -s ".lldbinit" "${HOME}/.lldbinit"
ln -s ".hushlogin" "${HOME}/.hushlogin"
ln -s ".hyper.js" "${HOME}/.hyper.js"

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