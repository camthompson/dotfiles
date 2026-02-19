# Migration: LazyVim → Self-Managed Config

## Testing

Test the new config in isolation (does not affect your current setup):

```sh
NVIM_APPNAME=nvim-new nvim
```

This uses separate dirs: `~/.local/share/nvim-new/`, `~/.config/nvim-new/`

## Validation Checklist

Work through these in order. Fix issues as you find them.

### Basic Startup
- [ ] `:Lazy` opens, all plugins installed without errors
- [ ] Colorscheme is catppuccin-mocha
- [ ] `:checkhealth` has no critical errors

### Core Editing
- [ ] `;` enters command mode, `:` repeats motion
- [ ] `<CR>` saves file (not in quickfix)
- [ ] `H` / `L` go to first/last non-blank char
- [ ] `g<CR>` stages file (`:Gwrite`)
- [ ] `vv` selects line content
- [ ] `Q` formats paragraph
- [ ] `<C-y>` / `<C-e>` scroll 5 lines
- [ ] `<C-s>` saves file

### Navigation
- [ ] `<C-h/j/k/l>` moves between tmux panes
- [ ] `<leader><leader>` opens git files (fzf)
- [ ] `<leader>ff` opens file finder
- [ ] `<leader>/` opens live grep
- [ ] `<leader>,` opens buffer switcher
- [ ] `,,` opens recent files (cwd)
- [ ] `<leader>e` opens neo-tree
- [ ] `-` opens oil file manager
- [ ] `<leader>h` opens harpoon menu
- [ ] `f`/`t` motions work (leap.nvim)

### LSP
- [ ] Open a Lua file → lua_ls attaches
- [ ] Open a Python file → basedpyright attaches (no diagnostics from it)
- [ ] Open a TypeScript file → vtsls attaches
- [ ] Open a JSON file → jsonls attaches with schema completion
- [ ] Open a Terraform file → terraformls attaches
- [ ] `gd` goes to definition (via fzf-lua)
- [ ] `gr` shows references (via fzf-lua)
- [ ] `K` shows hover docs
- [ ] `<leader>cr` renames symbol
- [ ] `<leader>ca` shows code actions

### Formatting & Linting
- [ ] Save a Lua file → stylua formats it
- [ ] Save a Python file → ruff formats it
- [ ] Save a TS file → oxfmt formats it
- [ ] Save a shell script → shfmt formats it
- [ ] Python files show mypy diagnostics
- [ ] TS files show oxlint diagnostics
- [ ] Dockerfiles show hadolint diagnostics
- [ ] `<leader>cf` manually formats

### Completion
- [ ] Completion popup appears in insert mode (blink.cmp)
- [ ] LSP completions show up
- [ ] Path completions work
- [ ] Snippet completions work
- [ ] Emoji completions work in markdown (type `:`)
- [ ] Cmdline completion works (type `:` then start typing)

### Git
- [ ] Gitsigns shows changes in gutter
- [ ] `]h` / `[h` navigate hunks
- [ ] `<leader>ghs` stages hunk
- [ ] `<leader>gg` opens lazygit
- [ ] `<leader>gG` opens neogit
- [ ] `:G` works (fugitive)
- [ ] `<leader>gv` opens deltaview
- [ ] `<leader>gr` opens CodeDiff against main

### UI
- [ ] Which-key popup shows on `<leader>`
- [ ] Noice handles command line UI
- [ ] Notifications show via snacks notifier
- [ ] `<leader>xx` opens trouble diagnostics
- [ ] `<leader>uB` toggles incline
- [ ] `<leader>td` / `<leader>tl` switch dark/light themes
- [ ] All `<leader>u*` toggles work (spell, wrap, numbers, etc.)

### Text Manipulation
- [ ] Surround: `ysiw"` wraps word in quotes
- [ ] Exchange: `cxiw` on two words swaps them
- [ ] `gS` / `gJ` split/join lines (splitjoin)
- [ ] `c=` toggles booleans (switch)
- [ ] `ch` / `cl` move arguments left/right (sideways)
- [ ] `[e` / `]e` move lines up/down (unimpaired)
- [ ] `p` / `P` paste with yanky, `<C-p>` / `<C-n>` cycle history

### AI
- [ ] Copilot suggestions appear in insert mode
- [ ] Sidekick works with `<C-.>` toggle

### Sessions
- [ ] `<leader>qs` restores session
- [ ] `<leader>ql` restores last session

## Known Potential Issues

1. **lang-typescript.lua** calls `require("lint.parser")` at file load time.
   If nvim-lint isn't loaded yet, this will error. Fix: wrap in a function.

2. ~~**Lualine** looks slightly different~~ — **Fixed.** Ported `root_dir()`
   and `pretty_path()` from LazyVim into `lualine.lua`.

3. **Sidekick** may have issues if it expects `LazyVim.cmp.map` for Tab
   keymap integration. Test the `<Tab>` key behavior in completion.

4. ~~**Format toggle**~~ — **Fixed.** `<leader>uf` (buffer) and `<leader>uF`
   (global) are wired up via Snacks toggles. `format_on_save` in conform
   checks `vim.b.autoformat` / `vim.g.autoformat`.

5. ~~**Copilot native**~~ — **Fixed.** Switched from `zbirenbaum/copilot.lua`
   to native LSP copilot via `vim.lsp.inline_completion`. Blink ghost text
   disabled to avoid conflicts. Sidekick status shown in lualine.

## Swap-Over (once everything works)

```sh
cd ~/src/dotfiles

# Back up current config
mv nvim nvim-lazyvim-backup

# Move new config into place
mv nvim-new nvim

# Clean plugin cache (fresh install)
rm -rf ~/.local/share/nvim/lazy
rm -rf ~/.local/state/nvim/lazy

# Remove test symlink
rm -f ~/.config/nvim-new

# Launch — lazy.nvim will install everything fresh
nvim

# Then run:
#   :TSUpdate
#   :Mason (verify tools are installed)
```

Keep `nvim-lazyvim-backup/` for a week as a safety net, then delete it.

## Rollback (if needed)

```sh
cd ~/src/dotfiles
mv nvim nvim-new          # save the new config
mv nvim-lazyvim-backup nvim  # restore LazyVim
rm -rf ~/.local/share/nvim/lazy  # clean install
nvim
```
