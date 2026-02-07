if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export MANPAGER='nvim +Man!'
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
  /Applications/MacVim.app/Contents/bin
  /opt/homebrew/bin/
  /usr/local/{bin,sbin}
  /usr/{bin,sbin}
  /{bin,sbin}
  $path
)

cdpath=(
  $HOME
  $HOME/src
  $HOME/work
)

export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

[[ -s $HOME/.zshenv.local ]] && source $HOME/.zshenv.local
