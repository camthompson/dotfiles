# Prereqs
1. Install [Homebrew](brew.sh)
2. `brew bundle`
3. `sudo echo '/usr/local/bin/zsh' >> /etc/shells`
4. `chsh -s /usr/local/bin/zsh cam` *Replace cam with your user name if you're not me*

# Dotfiles
## Setup
1. `./setup` *This will overwrite things in your home directory*
2. `mkdir vim/autoload`
3. `wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O vim/autoload/plug.vim`
4. Clone my Vim plugins into `vim/pack/bundle/start`

## Update
* `./update` will update submodules that contain ZSH dependencies
* From Vim, `:PlugUpgrade` and `:PlugUpdate` update `vim-plug` and other Vim add-ons, respectively

# Development
1. `ruby-install $VERSION`
2. `echo $VERSION > ~/.ruby-version`
3. `exec $SHELL`
4. `while read line; do gem install $line; done < default-gems`
5. Install [Node](nodejs.org)
6. `npm install -g yarn`
7. `yarn global add ember-cli`

# Non-Homebrew Apps
1. Install [iTerm2](https://iterm2.com/downloads.html) *because test builds aren't in cask*
2. Install [Slack](https://slack.com/beta/mac) *because beta builds aren't in cask*
3. Install [AirBuddy](https://gumroad.com/discover?query=airbuddy#HkXQH) *because it's on gumroad*
4. Install [Zoom](https://zoom.us/support/download) *because it's not in a cask*

# Misc Setup
1. Edit `/etc/ssh/sshd_config` and disable `PasswordAuthentication` and `ChallengeResponseAuthentication`
2. `sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist`
3. `sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist`
4. `sudo mv /etc/zprofile{,.bak}` to keep `path_helper` from screwing up `$PATH`
5. `defaults write com.apple.mail UserHeaders '{"Bcc" = "cam@camthompson.com"; }'`

## Credits
A lot of the ZSH stuff is pretty shamelessly ripped from [prezto](https://github.com/sorin-ionescu/prezto).
