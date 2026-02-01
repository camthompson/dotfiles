export PS1='\h:\w \$ '
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
source /usr/local/share/chruby/chruby.sh
[[ -s $HOME/.bashrc.local ]] && source $HOME/.bashrc.local

. "$HOME/.local/bin/env"
