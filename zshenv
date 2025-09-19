if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

export EDITOR='nvim'
export VISUAL='nvim'
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

[[ -s $HOME/.zshenv.local ]] && source $HOME/.zshenv.local

# Docker wrapper that handles build specially for k3s
function docker {
  if [[ "$1" == "build" ]]; then
    # Run the build command
    colima nerdctl -- "$@"
    # Extract image name from build command
    local image_name=""
    local next_is_tag=false
    for arg in "$@"; do
      if [[ "$next_is_tag" == true ]]; then
        image_name="$arg"
        break
      fi
      if [[ "$arg" == "-t" ]]; then
        next_is_tag=true
      fi
    done
    # If we found an image name, import it to k3s
    if [[ -n "$image_name" ]]; then
      echo "Importing $image_name to k3s..."
      colima nerdctl -- save "$image_name" | colima ssh -- sudo k3s ctr images import - >/dev/null 2>&1
      echo "Image $image_name available in k3s"
    fi
  else
    # For all other docker commands, just pass through
    colima nerdctl -- "$@"
  fi
}
