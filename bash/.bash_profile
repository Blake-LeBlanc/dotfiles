# export TESTBASHPROFILE=1

if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# eval $(ssh-agent)

# for background image at startup
# FIXME: This seems to run every time a new bash instance is instantiated. How can I separate it out
# so that it runs only on startup? With nothing to do with bash instance creations?
feh --randomize --bg-fill ~/dotfiles/wallpapers/.wallpapers --no-fehbg

# dotnet {{{
export DOTNET_CLI_TELEMETRY_OPTOUT=1

#}}}

# nnn{{{
export EDITOR=nvim

#}}}

# rust {{{
source "$HOME/.cargo/env"

#}}}

# rvm {{{
export NVM_DIR="$HOME/.nvm"
# load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# RVM can encounter errors if it's not the last thing in .bash_profile
# Add RVM to path for scripting (to manage Ruby versions)
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$GEM_HOME/bin:$PATH"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

#}}}
