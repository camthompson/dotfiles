# Setup
1. `./setup` This *will* overwrite things in your home directory.
2. `mkdir vim/autoload`
3. `wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O vim/autoload/plug.vim`

# Update
* `./update` will update submodules that contain ZSH dependencies
* From Vim, `:PlugUpgrade` and `:PlugUpdate` update `vim-plug` and other Vim addons, respectively

# Credits
A lot of the ZSH stuff is pretty shamelessly ripped from [prezto](https://github.com/sorin-ionescu/prezto).
