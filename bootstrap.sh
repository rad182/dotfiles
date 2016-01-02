#!/usr/bin/env bash

# function
installed() { hash $1 &> /dev/null; }

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
	source ~/.bash_profile;
	# Install Homebrew
	brew;
	# Install rvm
	rvm;
	# Install gems
	rubygems;
}

function brew() {
	# Homebrew
	if ! installed brew; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# install casks
	brew install caskroom/cask/brew-cask

	# install brewdler
	brew tap Homebrew/brewdler

	# install everything from Brewfile
	brew update
	brew upgrade --all
	brew brewdle
	brew linkapps
	brew cleanup
}

function rvm() {
	if ! installed rvm; then
		gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
		\curl -sSL https://get.rvm.io | bash -s stable --ruby
	fi
	brew cask cleanup
}

function rubygems() {
	gem install bundler
	bundle install
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;

unset doIt;
unset brew;
unset rvm;
unset rubygems;
