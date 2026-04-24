export PS1='\h:\w \$ '
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
# mise (runtime version manager)
if command -v mise &>/dev/null; then
  eval "$(mise activate bash)"
fi

[[ -s $HOME/.bashrc.local ]] && source $HOME/.bashrc.local

. "$HOME/.local/bin/env"
