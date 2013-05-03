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
alias view='v -R'

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

if [[ -x "/Applications/MacVim.app/Contents/MacOS/Vim" ]]; then
  alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
fi
