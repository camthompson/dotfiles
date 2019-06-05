# Prereqs
1. Install [Homebrew](brew.sh)
2. `brew bundle`
3. `sudo echo '/usr/local/bin/zsh' >> /etc/shells`
4. `chsh -s /usr/local/bin/zsh cam` *Replace cam with your user name if you're not me*

# Dotfiles
## Setup
1. `./setup` *This will overwrite things in your home directory*
2. `mkdir vim/autoload`
3. `wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O vim/autoload/plug.vim`
4. Clone my Vim plugins into `vim/pack/bundle/start`

## Update
* `./update` will update submodules that contain ZSH dependencies
* From Vim, `:PlugUpgrade` and `:PlugUpdate` update `vim-plug` and other Vim add-ons, respectively

## Credits
A lot of the ZSH stuff is pretty shamelessly ripped from [prezto](https://github.com/sorin-ionescu/prezto).
