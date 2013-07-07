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
  /usr/local/share/npm/bin/
  /usr/local/{bin,sbin}
  /usr/local/share/python
  /usr/local/share/python3
  /usr/local/heroku/bin
  /opt/local/bin
  /usr/{bin,sbin}
  /{bin,sbin}
  /opt/X11/bin
  $path
)

source /usr/local/share/chruby/chruby.sh
[[ -s $HOME/.zshenv.local ]] && source $HOME/.zshenv.local
