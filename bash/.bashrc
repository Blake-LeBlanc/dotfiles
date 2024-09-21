# export TESTBASHRC=1

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# pull in aliases from ~/.bash_aliases if exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# use vim commands
set -o vi

# To see what commands you use most often, can come in handy when looking what to alias
# $ history | awk '{cmd[$2]++} END {for(elem in cmd) {print cmd[elem] " " elem}}' | sort -n -r | head -10

# history settings  {{{
# Don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

HISTTIMEFORMAT="%F %T "

#}}}

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and
# subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# prompt config {{{
# https://scriptim.github.io/bash-prompt-generator/
# http://ezprompt.net/

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48 (ISO/IEC-6429). (Lack of such support is extremely rare, and
  # such a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# git branch (may introduce corrupt symbols, not escaped properly?) {{{
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "[${BRANCH}${STAT}]"
    else
        echo ""
    fi
}

function parse_git_dirty {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}
# Use like:
# export PS1="\`parse_git_branch\` "

#}}}

# strip colors (may not work reliably){{{
strip_colors() {
    sed 's/\\[eE][[0-9]*;[0-9]*m//g' <<< $PS1
    # You can use it like this
    #     PS1="..."
    #     export PS1=$(strip_colors)
}

#}}}

if [ "$color_prompt" = yes ]; then
    # PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\$ "
    # PS1="${debian_chroot:+($debian_chroot)}\u:\W\n\$ "

    # with git branch status info
    # PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\`parse_git_branch\`\n\$ "
    # PS1="${debian_chroot:+($debian_chroot)}\u:\W\`parse_git_branch\`\n\$ "

        # + jobs count and relative path
        # PS1="(jobs:\j) \${debian_chroot:+($debian_chroot)}\u:\W \`parse_git_branch\`\n\$ "

        # + jobs count and full path
        PS1="(jobs:\j) \${debian_chroot:+($debian_chroot)}\u:\$PWD \`parse_git_branch\`\n\$ "

else
    # PS1='${debian_chroot:+($debian_chroot)}\u:\W\$ '
    PS1="(jobs:\j) \${debian_chroot:+($debian_chroot)}\u:\$PWD \`parse_git_branch\`\n\$ "

fi
unset color_prompt force_color_prompt

#}}}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# CTRL+S settings  {{{
# Disables CTRL+S from stopping the terminal. As a sidenote, if you do ever accidentally go into
# this mode, you can get out of it with CTRL+Q
stty -ixon
export PATH=$HOME/bin:$PATH

if [ -f ~/.config/exercism/exercism_completion.bash  ]; then
    . ~/.config/exercism/exercism_completion.bash
fi

#}}}

# FZF {{{
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PATH=$HOME/bin:$PATH

# export FZF_TMUX=1

# Config for fd-find  {{{
# https://github.com/sharkdp/fd#integration-with-other-programs

  # export FZF_DEFAULT_COMMAND='fd --type file --hidden --exclude .git'
  export FZF_DEFAULT_COMMAND='fd . $HOME --type file --hidden --exclude .git'

  export FZF_DEFAULT_OPTS='--no-height'
  # export FZF_DEFAULT_OPTS='--no-height --bind <F2>:toggle-preview'

  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # NOTE: Disabling --preview options to improve speed and responsiveness
  # export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
    # NOTE: This requires bat
    #   $ cd ~/Downloads
    #   $ curl -LO https://github.com/sharkdp/bat/releases/download/v0.17.1/bat_0.17.1_amd64.deb
    #   $ sudo dpkg -i bat_0.17.1_amd64.deb

  export FZF_ALT_C_COMMAND='fd --type d . --hidden'
  # NOTE: Disabling --preview options to improve speed and responsiveness
  # export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

#}}}

# Config for ripgrep  {{{
#   NOTE: So here's the deal with FZF and ag/ack/ripgrep. FZF, by default, is set up to run natively with ack/ag variants.
#   Which means in order to set it up to use ripgrep, you need to configure FZF accordingly, which is what the below
#   commands accomplish...
#
# NOTE: These are search settings, one contains --no-ignore, one does not. Using no-ignore informs fzf to NOT respect
#   .gitignore and other such 'leave these out' files. Uncomment whichever you prefer
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
# export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
#
# NOTE: Sets up the <C-p> shortcut to launch FZF with ripgrep
# bind -x '"\C-p": vim $(fzf);'

#}}}

#}}}

# tmux settings   #{{{
# NOTE: The below code snippets dealing with 256color are an effort to get Vim's colorscheme to properly display when ran
# within tmux

# To see what color settings your active terminal is currently in, use '$ tput colors'
#
# https://bbs.archlinux.org/viewtopic.php?id=175581
#
# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color|*-256color) color_prompt=yes;;
# esac
# #
# # Attempt to set xfce terminal to use 256 colors
# case "$TERM" in
#   xterm*) TERM=xterm-256color
# esac
# #
# # Attempt to set the active terminal to use 256 colors
# if [ "$COLORTERM" == "gnome-terminal" ] || [ "$COLORTERM" == "xfce4-terminal" ]
# then
#   export TERM=xterm-256color
# elif [ "$COLORTERM" == "rxvt-xpm" ]
# then
#   export TERM=rxvt-256color
# fi
# #
# [ -z "$TMUX" ] && export TERM=xterm-256color

#}}}

# Keep bash session open when starting with custom commands (ie as in terminator layouts)
# [[ $startup_cmd ]] && { declare +x $startup_cmd; eval "startup_cmd"; }

# keyboard repeat delay and repeat interval settings {{{
 # NOTE: Default setting is somewhere around 660 25
if [ ! -z "DISPLAY" ]; then
  # Default values
  # xset r rate 660 25
  xset r rate 225 40
fi

#}}}

# ssh-agent related settings  {{{
# prompt for passphrase once upon login, forget on system shutdown/logout
# https://unix.stackexchange.com/a/217223/269108
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval 'ssh-agent'
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

#}}}

# stty {{{
# NOTE: In Lubuntu 19.04 base, using <C-h> to switch panes leftward instead seems to produce the backspace key, which from
# what I've read is equivalent to <C-?>. To remedy this, you supposedly need to edit some the stty inputs so the keypress is
# no longer 'mis-interpreted'
# UPDATE: There is a chance this may introduce conflicts with use of <Backspace>, requring to use <C-backspace> instead. This
# does not appear to be an issue at the moment, but in case it ever comes up, the following resource may come in handy
# https://stackoverflow.com/questions/9701366/vim-backspace-leaves

stty erase '^?'

#}}}

# julia {{{
# export PATH="$PATH:$HOME/julia-1.4.2/bin"
  # NOTE: I couldn't get this approach to work, had to go the symlink route

#}}}

# libvips and related {{{
export VIPSHOME=/usr/local
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$VIPSHOME/lib
export PATH=$PATH:$VIPSHOME/bin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$VIPSHOME/lib/pkgconfig
export MANPATH=$MANPATH:$VIPSHOME/man
export PYTHONPATH=$VIPSHOME/lib/python2.7/site-packages

#}}}

# Neovim#{{{
    export PATH="$HOME/neovim/bin:$PATH"

#}}}

# nnn{{{
export EDITOR=nvim

#}}}

# pip3 {{{
  export PATH="$HOME/.local/bin:$PATH"

#}}}

# pyenv {{{
    # NOTE: DISABLED
    # export PATH="$HOME/.pyenv/bin:$PATH"
    # eval "$(pyenv init --path)"
    # eval "$(pyenv init -)"
    # eval "$(pyenv virtualenv-init -)"

    # From https://github.com/pyenv/pyenv-virtualenv/issues/233#issuecomment-849928428
    # export PYENV_ROOT="$HOME/.pyenv"
    # export PATH="$PYENV_ROOT/bin:$PATH"
    # eval "$(pyenv init --path)"
    # eval "$(pyenv init -)"
    # eval "$(pyenv virtualenv-init -)"

    # From https://stackoverflow.com/a/62516625
    # if command -v pyenv 1>/dev/null 2>&1; then
    # eval "$(pyenv init -)"
    # fi
    # export PYENV_ROOT="$HOME/.pyenv"
    # export PATH="$PYENV_ROOT/bin:$PATH"
    # if command -v pyenv 1>/dev/null 2>&1; then
    # eval "$(pyenv init -)"
    # fi

# }}}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="/home/linux/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# gvm
[[ -s "/home/linux/.gvm/scripts/gvm" ]] && source "/home/linux/.gvm/scripts/gvm"
