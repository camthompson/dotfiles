# Prereqs

1. Install [Homebrew](brew.sh)
2. `brew bundle`
3. `sudo su`
4. `echo '/usr/local/bin/zsh' >> /etc/shells`
5. `exit`
6. `chsh -s /usr/local/bin/zsh`

# Dotfiles

## Setup

1. `./setup` _This will overwrite things in your home directory_

## Update

- `./update` will update submodules that contain ZSH dependencies
- In NeoVim, `:Lazy` will open the plugin update interface

# Misc Setup

1. `git clone camthompson/bin ~/bin`
2. `sudo post-macos-update`

# Backblaze

`open '/usr/local/Caskroom/backblaze/latest/Backblaze Installer.app'`

## Credits

A lot of the ZSH stuff is pretty shamelessly ripped from [prezto](https://github.com/sorin-ionescu/prezto).
