setopt NO_BEEP            # Shut up.
setopt BRACE_CCL          # Allow brace character class list expansion.
setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.
setopt EXTENDED_GLOB      # This is necessary for a lot of stuff.
setopt NO_CASE_GLOB       # Glob without case sensitivity.
setopt MULTIOS            # Write to multiple descriptors.
unsetopt CLOBBER          # Do not overwrite existing files with > and >>.
                          # Use >! and >>! to bypass.

# Disable flow control
stty stop undef
stty start undef

func_glob='^([_.]*|prompt_*_setup)(.N:t)'
for func ($HOME/.zsh/func/$~func_glob) autoload -Uz $func; unset func func_glob

# Aliases {{{
alias %=' '
alias $=' '

alias c=cd
for index ({1..9}) alias "$index"="cd +${index}"; unset index
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias tl='tmux ls'

alias l='ls -GF'
alias ll='ls -lhGF'
alias la='ls -ahGF'
alias lal='ls -lhaGF'
alias laf='ls -aGF'

alias v=vim
alias m='v -g'
alias vd='v -d'
alias vw='v -R'

alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/logfile start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

alias rm='rm -i'
alias mkdir='mkdir -p'
alias md='mkdir'
alias mv='mv -i'
alias cp='cp -i'
alias d='dirs -v'
alias f=fg
alias bc='bc -q'
alias ip='curl www.icanhazip.com'
alias p='ping -o'
alias d='dirs -v'

alias rb='ruby'

alias mi='bundle exec rake db:migrate db:test:prepare'
alias rst='touch tmp/restart.txt'
alias rlog='tail -f log/development.log'

alias bi='bundle install'
alias bid='bundle install --without production'
alias b='bundle exec'
alias br='bundle exec rails'

alias rr='rbenv rehash'

alias duh='du -ch'

_rsync_cmd='rsync --verbose --progress --human-readable --compress --archive --hard-links --one-file-system'

# Mac OS X and HFS+ Enhancements
# http://www.bombich.com/rsync.html
if [[ "$OSTYPE" == darwin* ]] && grep -q 'file-flags' <(rsync --help 2>&1); then
  _rsync_cmd="${_rsync_cmd} --crtimes --acls --xattrs --fileflags --protect-decmpfs --force-change"
fi

alias rsync-copy="${_rsync_cmd}"
alias rsync-move="${_rsync_cmd} --remove-source-files"
alias rsync-update="${_rsync_cmd} --update"
alias rsync-synchronize="${_rsync_cmd} --update --delete"

unset _rsync_cmd

# Disable globbing.
alias fc='noglob fc'
alias find='noglob find'
alias ftp='noglob ftp'
alias history='noglob history'
alias locate='noglob locate'
alias rake='noglob rake'
alias rsync='noglob rsync'
alias scp='noglob scp'
alias sftp='noglob sftp'

alias s='sudo'

alias tm=tmux
# }}}

# Colors {{{
export GREP_OPTIONS='--color=auto'
export ACK_COLOR_MATCH='red'

export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[0;36m'       # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[0;30;44m'    # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[0;32m'       # Begins underline.

if which dircolors > /dev/null; then
  # GNU Core Utilities
  alias ls='ls --group-directories-first'

  if [[ -s "$HOME/.dir_colors" ]]; then
    eval "$(dircolors "$HOME/.dir_colors")"
  else
    eval "$(dircolors)"
  fi

  alias ls="$aliases[ls] --color=auto"
else
  # BSD Core Utilities
  # Define colors for BSD ls.
  export LSCOLORS='exfxcxdxbxGxDxabagacad'

  # Define colors for the completion system.
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'
fi
# }}}

# Completion {{{
autoload -Uz compinit && compinit -i

setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
setopt MENU_COMPLETE       # Autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Populate hostname completion.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users...
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# Mutt
if [[ -s "$HOME/.mutt/aliases" ]]; then
  zstyle ':completion:*:*:mutt:*' menu yes select
  zstyle ':completion:*:mutt:*' users ${${${(f)"$(<"$HOME/.mutt/aliases")"}#alias[[:space:]]}%%[[:space:]]*}
fi

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order users 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# <cr> in menu selects and sends command
zmodload zsh/complist
bindkey -M menuselect '^M' .accept-line
# }}}

# Directories {{{
autoload -Uz zmv

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
# }}}

# Editor {{{
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
bindkey -M viins '^N' history-substring-search-down
bindkey -M viins '^O' history-substring-search-up
bindkey -M vicmd '^R' redo
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M viins ' ' magic-space
bindkey '^[[Z' reverse-menu-complete
bindkey -M viins '^U' backward-kill-line
# vim:set ft=zsh:
# }}}

# Functions {{{
function g {
  if [[ $# > 0  ]]; then
    git $@
  else
    git status --short --ignore-submodules
  fi
}
compdef g=git

function mcd {
  mkdir -p "$*" && cd "$*"
}
# }}}

# History {{{
HISTFILE="${ZDOTDIR:-$HOME}/.zhistory"       # The path to the history file.
HISTSIZE=100000                   # The maximum number of events to save in the internal history.
SAVEHIST=100000                   # The maximum number of events to save in the history file.

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt NO_HIST_BEEP              # Don't beep when accessing non-existent history.
# }}}

autoload -Uz promptinit && promptinit
prompt cet

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=black'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white'

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source $HOME/.zsh/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
