#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE" --exclude "Brewfile" --exclude "Gemfile" -avh --no-perms . ~;
	source ~/.bash_profile;
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
	# Add rbenv init to your shell to enable shims and autocompletion.
	echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
	source ~/.bash_profile
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
