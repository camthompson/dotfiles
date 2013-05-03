function g {
  if [[ $# > 0  ]]; then
    git $@
  else
    git status --short --ignore-submodules
  fi
}
compdef g=git
