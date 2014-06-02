if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export LESS='-F -g -i -M -R -S -w -X -z-4'

if [[ -z "$LANG" ]]; then
  eval "$(locale)"
fi

typeset -gU fpath path

fpath=(
  $HOME/.zsh/bundle/completions/src
  $HOME/.zsh/func
  $fpath
)

path=(
  $HOME/bin
  /usr/local/share/npm/bin
  /usr/local/{bin,sbin}
  /usr/local/heroku/bin
  /opt/local/bin
  /usr/{bin,sbin}
  /{bin,sbin}
  /opt/X11/bin
  $path
)

cdpath=(
  $HOME
  $HOME/src
)

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
[[ -s $HOME/.zshenv.local ]] && source $HOME/.zshenv.local
