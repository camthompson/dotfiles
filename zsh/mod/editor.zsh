zmodload zsh/terminfo

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic
autoload -Uz edit-command-line
zle -N edit-command-line

bindkey -v

export KEYTIMEOUT=1

source $HOME/.zsh/bundle/history-substring-search/zsh-history-substring-search.zsh

function editor-info {
  # Clean up previous $editor_info.
  unset editor_info
  typeset -gA editor_info

  if [[ "$KEYMAP" == 'vicmd' ]]; then
    zstyle -s ':keymap:command' format 'REPLY'
    editor_info[keymap]="$REPLY"
  else
    if [[ "$ZLE_STATE" == *overwrite* ]]; then
      zstyle -s ':keymap:overwrite' format 'REPLY'
      editor_info[keymap]="$REPLY"
    else
      zstyle -s ':keymap:insert' format 'REPLY'
      editor_info[keymap]="$REPLY"
    fi
  fi

  unset REPLY

  zle reset-prompt
  zle -R
}
zle -N editor-info

function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( $+terminfo[smkx] && $+terminfo[rmkx] )); then
    case "$0" in
      (zle-line-init)
        # Enable terminal application mode.
        echoti smkx
      ;;
      (zle-line-finish)
        # Disable terminal application mode.
        echoti rmkx
      ;;
    esac
  fi

  # Update editor information.
  zle editor-info
}
zle -N zle-keymap-select
zle -N zle-line-finish
zle -N zle-line-init

# Toggles emacs overwrite mode and updates editor information.
function overwrite-mode {
  zle .overwrite-mode
  zle editor-info
}
zle -N overwrite-mode

# Enters vi insert mode and updates editor information.
function vi-insert {
  zle .vi-insert
  zle editor-info
}
zle -N vi-insert

# Moves to the first non-blank character then enters vi insert mode and updates
# editor information.
function vi-insert-bol {
  zle .vi-insert-bol
  zle editor-info
}
zle -N vi-insert-bol

# Enters vi replace mode and updates editor information.
function vi-replace  {
  zle .vi-replace
  zle editor-info
}
zle -N vi-replace

bindkey -M vicmd v edit-command-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^B' backward-char
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^E' end-of-line
bindkey -M viins '^F' forward-char
bindkey -M viins '^K' kill-line
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
bindkey -M viins '^T' transpose-chars
bindkey -M viins '^Y' yank
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^[[3~' delete-char
bindkey -M vicmd 'u' undo
bindkey -M vicmd '^R' redo
bindkey -M viins '^P' history-substring-search-up
bindkey -M viins '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M viins ' ' magic-space
bindkey '^[[Z' reverse-menu-complete
# vim:set ft=zsh:
