#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE" --exclude "Brewfile" --exclude "Gemfile" -avh --no-perms . ~;
	source ~/.bash_profile;

    # Ask for the administrator password upfront.
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until the script has finished.
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

	# Install Homebrew
	homebrew;
	# Install ruby and gems
	rubygems;
}

function homebrew() {
	# Homebrew
	if ! type brew > /dev/null; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi

	# install everything from Brewfile
	brew update
	brew upgrade --all
	brew bundle --verbose
	brew linkapps
	brew cleanup
	brew cask cleanup
}

function rubygems() {
	# Initialize rbenv
	eval "$(rbenv init -)"
	# install latest ruby
	RUBY_VERSION=`rbenv install -l | sed -n '/^[[:space:]]*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}[[:space:]]*$/ h;${g;p;}'`
	if ! rbenv versions --bare | grep $RUBY_VERSION; then
  	rbenv install $RUBY_VERSION
	fi
	rbenv global $RUBY_VERSION
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
unset homebrew;
unset rubygems;
