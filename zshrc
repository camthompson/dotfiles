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

for mod ($HOME/.zsh/mod/*.zsh) source $mod; unset mod
func_glob='^([_.]*|prompt_*_setup)(.N:t)'
for func ($HOME/.zsh/func/$~func_glob) autoload -Uz $func; unset func func_glob

autoload -Uz promptinit && promptinit
prompt cetsolarized

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source $HOME/.zsh/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -s $HOME/.zshrc.local ]] && source $HOME/.zshrc.local
