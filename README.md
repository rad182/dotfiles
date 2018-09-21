# Royce Dy's dotfiles

My config files to setup my OSX development environment heavily inspired from [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

Download and Install [Meslo Powerline Font](https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf)

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/Projects/dotfiles`, with `~/dotfiles` as a symlink.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/rad182/dotfiles.git && cd dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.macos
```

### Additional Setup

- Setup gpg after https://github.com/pstadler/keybase-gpg-github
- VSCode https://code.visualstudio.com/download
  - Install the sync extension to install the other extensions
- Xcode https://developer.apple.com/download/more
- Docker https://docs.docker.com/docker-for-mac/install/
- Adware + Malware Blocking Hosts https://github.com/StevenBlack/hosts

## Credits

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) and all the contributors
