set -g status-bg black
set -g status-fg brightblack
setw -g window-status-current-fg green
setw -g window-status-current-attr default
set -g pane-border-fg brightblack
set -g pane-active-border-fg green
set -g display-panes-active-colour magenta
set -g display-panes-colour black
set -g status on
set -g status-utf8 on
set -g status-justify "centre"
set -g status-left-length 60
set -g status-right-length 90
set -g status-left "#h | #S:#I.#P"
set -g status-right "#(tmux_battery_life) | #(tmux_date) #(tmux_time)"
set -g window-status-format "#I-#W"
set -g window-status-current-format "[#I-#W]"
set -g mode-bg brightyellow
set -g mode-fg white
