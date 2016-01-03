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
	# Install ruby and gems
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
	brew cask cleanup
}

function rubygems() {
	# initialize rbenv
	eval "$(rbenv init -)"
	# install ruby 2.3.0 is the latest as of this writing
	rbenv install 2.3.0
	rbenv global 2.3.0
	rbenv rehash
	# install bundler gem
	gem install bundler
	# install all gems from the Gemfile
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
unset rubygems;
