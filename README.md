# Prereqs
1. Install [Homebrew](brew.sh)
2. `brew bundle`
3. `sudo su`
4. `echo '/usr/local/bin/zsh' >> /etc/shells`
5. `exit`
6. `chsh -s /usr/local/bin/zsh`

# Dotfiles
## Setup
1. `./setup` *This will overwrite things in your home directory*
2. Clone my Vim plugins into `vim/pack/bundle/start`
3. In Vim, `:PlugInstall` and `CocInstall`

## Update
* `./update` will update submodules that contain ZSH dependencies
* From Vim, `:PlugUpgrade` and `:PlugUpdate` update `vim-plug` and other Vim add-ons, respectively
* Also in Vim, `:CocUpdate` will update completion plugins

# Misc Setup
1. `git clone camthompson/bin ~/bin`
2. `sudo post-macos-update`

# Backblaze
`open '/usr/local/Caskroom/backblaze/latest/Backblaze Installer.app'`

# Dynamic IP
`mkdir -p "$HOME/Library/LaunchAgents"`
`ln -s "$PWD/com.camthompson.macos.updateip.plist" "$HOME/Library/LaunchAgents/com.camthompson.macos.updateip.plist"`

## Credits
A lot of the ZSH stuff is pretty shamelessly ripped from [prezto](https://github.com/sorin-ionescu/prezto).
