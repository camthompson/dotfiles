# New Computer Setup
1. `sudo xcode-select --install`

# Prereqs
1. Install [Homebrew](brew.sh)
2. `brew bundle`
3. `sudo su`
4. `echo '/usr/local/bin/zsh' >> /etc/shells`
5. `exit`
6. `chsh -s /usr/local/bin/zsh`

# Dotfiles
## Setup
1. `./setup` *This will overwrite things in your home directory*
2. Clone my Vim plugins into `vim/pack/bundle/start`

## Update
* `./update` will update submodules that contain ZSH dependencies
* From Vim, `:PlugUpgrade` and `:PlugUpdate` update `vim-plug` and other Vim add-ons, respectively

# Misc Setup
1. `g clone camthompson/bin ~/bin`
2. Edit `/etc/ssh/sshd_config` and disable `PasswordAuthentication` and `ChallengeResponseAuthentication`
3. `sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist`
4. `sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist`
5. `sudo mv /etc/zprofile{,.bak}` to keep `path_helper` from screwing up `$PATH`

# Backblaze
`open '/usr/local/Caskroom/backblaze/latest/Backblaze Installer.app'`

# Dynamic IP
`mkdir -p "$HOME/Library/LaunchAgents"`
`ln -s "$PWD/com.camthompson.macos.updateip.plist" "$HOME/Library/LaunchAgents/com.camthompson.macos.updateip.plist"`

## Credits
A lot of the ZSH stuff is pretty shamelessly ripped from [prezto](https://github.com/sorin-ionescu/prezto).
