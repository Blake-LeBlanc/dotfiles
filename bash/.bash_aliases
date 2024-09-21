# `$ alias` List all defined aliases
# `$ declare -F` List all functions
# `$ type <command>` Show alias associated with command
# `$ set | less` List env variables
# `$ declare -xp` List env variables
# `$ ( set -o posix ; set ) | less` List shell and env variables 
# `$ declare -x` List variables
# `$ compgen -v  | sort | while read var; do [ -z "${!var}" ] || echo $var=${!var} ; done`

# enable programmable completion features
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi

  # alias anythingtoalias="$ history | awk '{cmd[$2]++} END {for(elem in cmd) {print cmd[elem] \" \" elem}}' | sort -n -r | head -10"

  function hist() {
    history | awk '{cmd[$2]++} END {for(elem in cmd) {print cmd[elem] " " elem}}' | sort -n -r | head -10
  }

# active server list  {{{
  servers() {
    lsof -wni tcp:3000
  }

  # QUESTION: Is it possible to pass in an argument with a function like this?
  # k(number) {
  #   kill -9 number
  # }
#}}}

# alert {{{
  #   sleep 10; alert
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#}}}

# diagnose boot times {{{
timestamp=$(date "+%Y%m%d%H%M%S")

alias diagnose_boot="systemd-analyze critical-chain > ~/system.boot.$timestamp.critical_chain.txt && \
                    systemd-analyze blame > ~/system.boot.$timestamp.blame.txt && \
                    systemd-analyze plot > ~/system.boot.$timestamp.plot.svg && \
                    dmesg > ~/system.boot.$timestamp.dmesg.txt && \
                    sudo systemctl list-unit-files --state=enabled > ~/system.boot.$timestamp.unit_files_enabled.txt && \
                    journalctl --dmesg > ~/system.boot.$timestamp.journalctl.txt && \
                    cat /etc/fstab > ~/system.boot.$timestamp.fstab.txt && \
                    sudo blkid > ~/system.boot.$timestamp.blkid.txt"

alias diagnose_vim="vim --startuptime ~/vim.boot.$timestamp.log"

#}}}

# display 256 color Palette  {{{
  # You can use this just like you would an alias, simply type `$ colors` and it will render. One advantage of this
  # approach compared to creating an alias is that with the function, the command can be referenced just as it would be
  # type do in the command-line, whereas with an alias, certain characters must be properly escaped.
  colors() {
    for i in {0..255}; do printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ; if ! (( ($i + 1 ) % 8 )); then echo ; fi ; done
  }

  # $ wget http://www.vim.org/scripts/download_script.php?src_id=4568 -O colortest
  # $ perl colortest -w

#}}}

# dotfiles git repo  {{{
  # UPDATE: It's causing more trouble than it's worth now, I think there may still be some lingering
  # conflicts between the old and new dotfiles command alias because it seems to be pulling in both
  # setups rather than *just* those in the stow related dotfiles parent directory. Commenting out
  # for now, will just use standard `$ git` related commands from the dotfiles parent directory
  # instead

  # alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=/$HOME'
  # UPDATE: Stow version
  # alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/.git/ --work-tree=/$HOME/dotfiles'
  DOTFILES="$HOME/dotfiles"

#}}}

# dwm {{{
  # alias dwmupdate="cd /usr/share/dwm && sudo make clean install"
  alias dwmupdate="cd $TEMP_DWM && sudo make clean install"

#}}}

# fonts {{{
  # alias cachefonts="rm /etc/fonts/conf.d/70-no-bitmaps.conf && fc-cache -f -v"
  alias cachefonts="fc-cache -f -v"

#}}}

# FZF {{{
fshow() {
  # git log --graph --color=always \
  #     --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  git lg |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

alias glNoGraph='git log --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr% C(auto)%an" "$@"'
_gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
_viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"

# fcoc_preview - checkout git commit with previews
fcoc_preview() {
  local commit
  commit=$( glNoGraph |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
        --ansi --preview="$_viewGitLogLine" ) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# fshow_preview - git commit browser with previews
fshow_preview() {
    glNoGraph |
        fzf --no-sort --reverse --tiebreak=index --no-multi \
            --ansi --preview="$_viewGitLogLine" \
                --header "enter to view, alt-y to copy hash" \
                --bind "enter:execute:$_viewGitLogLine   | less -R" \
                --bind "alt-y:execute:$_gitLogLineToHash | xclip"
}

fmpc() {
  local song_position
  song_position=$(mpc -f "%position%) %artist% - %title%" playlist | \
    fzf-tmux --query="$1" --reverse --select-1 --exit-0 | \
    sed -n 's/^\([0-9]\+\)).*/\1/p') || return 1
  [ -n "$song_position" ] && mpc -q play $song_position
}

#}}}

# ghostscript{{{
  function compresspdf() {
    # FIXME: How do you handle input and output files with multiple spaces, passed in as an arg?
    filename=${1//\\} \
    filename_without_extension=${filename%.*} \

    gs -q -dNOPAUSE -dBATCH -dSAFER \
    -sDEVICE=pdfwrite \
    -dCompatibilityLevel=1.4 \
    -dPDFSETTINGS=/screen \
    -dEmbedAllFonts=true \
    -dSubsetFonts=true \
    -dColorImageDownSampleType=/Bicubic \
    -dColorImageResolution=144 \
    -dGrayImageDownSampleType=/Bicubic \
    -dGrayImageResolution=144 \
    -dMonoImageDownSampleType=/Bicubic \
    -dMonoImageResolution=144 \
    -sOutputFile="${filename_without_extension}.ghost_comp.pdf" \
    "${1}"

  }

  # NOTE: On looping through each of the `find` results
  # FIXME: How to 'exec' the compresspdf function with each file passed in as an arg?
  # $ find . -name "*.pdf" -exec echo {} \;
  # $ fd -c pdf <then what???>

#}}}

# git related aliases  {{{
  # NOTE: The `$ git <xyz>` aliases are stored separately in the .gitconfig, this allows them to be
  # called with the prefixing `git` command

  alias ga="git add ."
  alias gA="git add -A"
  alias gc="git commit"
  alias gcm="git commit -m"
  alias gd="git diff"
  alias gpl="git pull --all"
  alias gps="git push --all"
  alias gs="git status"
  # alias gl="git lg"
  alias gl="fshow"

  function gittracked() {
    git ls-tree -r HEAD --name-only
  }

  function gittrackedforever() {
    # git log --pretty=format: --name-only --diff-filter=A | sort - | sed '/^$/d'
    git log --pretty=format: --name-only --all | sort -u | sed '/^$/d'
  }

#}}}

# install and update related {{{
  # TODO: Move stow related "follow-up" actions into their own install sections
  # TODO: Add some sort of way to view the ongoing progress, something like "Start"/"End" pairs for
  # each install section. Rather than outputing to a terminal, maybe output it to a timestamped .log
  # file instead?

  TEMP_BTOP="$HOME/temp_btop"
  TEMP_DOTNET="$HOME/temp_dotnet"
  TEMP_DWM="$HOME/temp_gitdwm"
  TEMP_LIBEVENT="$HOME/temp_libevent"
  TEMP_LIBUV="$HOME/temp_libuv"
  TEMP_LIBVIPS="$HOME/temp_gitlibvips"
  TEMP_LUA="$HOME/temp_lua"
  TEMP_LY="$HOME/temp_gitly"
  TEMP_MONO="$HOME/temp_mono"
  TEMP_NEOVIM="$HOME/temp_gitneovim"
  TEMP_NIP2="$HOME/temp_gitnip2"
  TEMP_NNN="$HOME/temp_nnn"
  OMNIROS="$HOME/.local/omnisharp_roslyn"
  TEMP_TASKWARRIOR="$HOME/temp_gittaskwarrior"
  TEMP_TMUX="$HOME/temp_tmux"
  TEMP_UNITY="$HOME/temp_unity"
  TEMP_VIM="$HOME/temp_gitvim"

  function installomnisharproslyn() {
    curl --verbose --location --remote-name https://github.com/omnisharp/omnisharp-roslyn/releases/latest/download/omnisharp-linux-x64.tar.gz
    mkdir -p $OMNIROS
    mv omnisharp-linux-x64.tar.gz $OMNIROS
    cd $OMNIROS
    tar -xvf omnisharp-linux-x64.tar.gz

  }

  function installdotnet() {
    mkdir $TEMP_DOTNET &&
    cd $TEMP_DOTNET &&
    # wget https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    sudo apt update; \
      sudo apt install -y apt-transport-https && \
      sudo apt update && \
      sudo apt install -y dotnet-sdk-6.0

    # https://docs.microsoft.com/en-us/dotnet/core/install/linux-scripted-manual#scripted-install
    # wget https://dot.net/v1/dotnet-install.sh
    # ./dotnet-install.sh -c Current


  }

  function installunity() {
    sudo sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list'
    wget -qO - https://hub.unity3d.com/linux/keys/public | sudo apt-key add -

    sudo apt update &&
    sudo apt install unityhub

  }

  function installmono() {
    sudo apt-get install git autoconf libtool automake build-essential gettext cmake python3 curl -y

    # Attempt 1
    # PREFIX=/usr/local
    # git clone https://github.com/mono/mono.git $TEMP_MONO &&
    # cd $TEMP_MONO &&
    # ./autogen.sh --prefix=$PREFIX &&
    # sudo make &&
    # sudo make install 
      # NOTE: I forget what I did now, but there was SOME variation of the above that actually
      # seemed to work. I fired up the unity stuff and the lsp actually kicked in and did some
      # things

    # Attempt 2
    # git clone https://github.com/mono/mono.git $TEMP_MONO &&
    # cd $TEMP_MONO &&
    # ./autogen.sh &&
    # sudo make &&
    # sudo make install 

    # Attempt 3
    # PREFIX='/usr/local'
    # PATH=$PREFIX/bin:$PATH
    # git clone https://github.com/mono/mono.git $TEMP_MONO &&
    # cd $TEMP_MONO &&
    # ./autogen.sh --prefix=$PREFIX &&
    # sudo make &&
    # sudo make install 

    # Attempt 4
    # https://www.mono-project.com/download/stable/
    sudo apt install gnupg ca-certificates
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
    sudo apt update && \
    sudo apt install mono-complete -y && \
    sudo apt install msbuild -y

    # Sample cs proj to test install
    # https://www.mono-project.com/docs/getting-started/mono-basics/

  }

  function update() {
    sudo apt update -y && \
    sudo apt dist-upgrade -y && \
    sudo apt auto-remove -y && \
    sudo apt autoclean -y && \
    sudo apt clean -y

  }

  function enablesourcerepos() {
    sudo sed -i '/deb-src/s/^# //' /etc/apt/sources.list && apt update

  }

  function disablesourcerepos() {
    sudo sed -i '/deb-src/s/^/# /' /etc/apt/sources.list && apt update

  }

  function installall() {
    # FIXME: Do some sort of try catch for enablesourcerepos
    # enablesourcerepos
    installbase &&
    # installstow &&
    # installvim &&
      # NOTE: Already part of installbase
    installdwm &&
    # gitinstalldwm
      # NOTE: Already part of installdwm
    installpywal &&
    installrust &&
    installterminalrelated &&
    stowall

  }

  function installvscode() {
      sudo apt install software-properties-common apt-transport-https -y && \
      sudo wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add - && \
      sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" && \
      sudo apt update && \
      sudo apt install code

  }

  function installbase() {
    sudo apt update
    sudo apt install libgnutls28-dev -y &&
    sudo apt install cmake -y &&
    sudo apt install uuid-dev -y &&
    sudo apt install snap -y &&
    sudo apt install python3-pip -y &&
    sudo apt install fd-find -y &&
    sudo apt install conky-all -y &&
    sudo apt install galternatives -y &&
    sudo apt install imwheel -y &&
    sudo apt install tmux -y &&
    sudo apt install tmuxp -y &&
    sudo apt install vifm -y &&
    sudo apt install neofetch -y &&
    sudo apt install pcmanfm -y &&
    installnvmandrelated &&
    installvim &&
    installterminals &&
    installzathura &&
    installcapybararelated &&
    installtaskwarriorrelated &&
    installresourcemonitors &&
    installdiskspacetools &&
    installbrave &&
    installelinks &&
    installnnn &&
    pip3 install tmuxp &&
    installfonts
    # gitinstallly

  }

  function gitinstalllibevent() {
    git clone https://github.com/libevent/libevent.git $TEMP_LIBEVENT
    cd $TEMP_LIBEVENT
    sudo sh autogen.sh && \
    sudo ./configure && \
    sudo make && \
    sudo make install

  }

  function gitinstalltmux() {
    gitinstalllibevent && 
    git clone https://github.com/tmux/tmux.git $TEMP_TMUX
    cd $TEMP_TMUX
    sudo sh autogen.sh && \
    sudo ./configure && \
    sudo make && \ 
    sudo make install

  }

  function installlibuv() {
    # wget https://github.com/libuv/libuv/archive/refs/tags/v1.44.2.tar.gz

    sudo git clone https://github.com/libuv/libuv/ $TEMP_LIBUV
    cd $TEMP_LIBUV
    sudo sh autogen.sh && \
    sudo ./configure && \
    sudo make && \
    sudo make check && \
    sudo make install

  }

  function installnnn() {
    sudo apt-get install pkg-config -y &&
    sudo apt install libncursesw5-dev -y &&
    sudo apt install libreadline-dev -y &&
    # sudo make strip install

    # wget https://github.com/jarun/nnn/releases/latest $TEMP_NNN
      # FIXME: How to target specific file on the page?

    # sudo git clone https://github.com/jarun/nnn/releases/latest $TEMP_NNN
    sudo git clone https://github.com/jarun/nnn/ $TEMP_NNN
    sudo make &&
    sudo make install

  }

# NOTE: If this fails on the first attempt, simply run it again. I suspect it has something to
# do with the environment change not taking effect
  function installnvmandrelated() {
    cd
    mkdir ~/.nvm
    sudo curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    # Load nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    # Load nvm bash_completion
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    command -v nvm
    nvm --version
    nvm install node &&
    nvm install-latest-npm

  }

  function installbpytop() {
    sudo snap install bpytop &&
    sudo snap connect bpytop:mount-observe &&
    sudo snap connect bpytop:network-control &&
    sudo snap connect bpytop:hardware-observe &&
    sudo snap connect bpytop:system-observe &&
    sudo snap connect bpytop:process-control &&
    sudo snap connect bpytop:physical-memory-observe 

  }

  function installterminals() {
    sudo apt install xfce4-terminal -y &&
    sudo apt install rxvt rxvt-unicode rxvt-unicode-256color -y &&
    sudo apt install lxterminal -y

  }

  # FIXME: Not working quite like you want it to.
  function setdefaultterminal() {
    exec $SHELL
    sudo update-alternatives --set x-terminal-emulator $(which xfce4-terminal)

  }

  # function installcargo() {
  #   curl https://sh.rustup.rs -sSf | sh
  #
  # }

  function installtealdeer() {
    cargo install tealdeer

  }

  function installxplr() {
    cargo install --force xplr

  }

  function installnavi() {
    cargo install --force navi

  }

  function installgitui() {
    cargo install gitui

  }

  function installthefuck() {
    pip3 install thefuck --user

  }

  function installterminalrelated() {
    installgitui
    installnavi
    installtealdeer
    installxplr
    installthefuck

  }

  function xres() {
    xrdb ~/.Xresources

  }

  function installresourcemonitors() {
    # installbpytop
    # sudo snap install glances
    # sudo snap install htop
    cargo install bottom --locked && 
    pip3 install glances &&
    sudo apt install htop -y &&
    installbtop

  }

  function installdiskspacetools() {
    sudo apt install gdmap -y &&
    cargo install dua-cli &&
    cargo install du-dust &&
    cargo install dutree 

  }

  function installbtop() {
    # NOTE: I'd really like to try this one out, but I can't get the build to go through. Evidently
    # gcc-10 and g++-10 can sometimes be really difficult to get up and running on some systems.
    sudo apt install coreutils -y &&
    sudo apt install sed -y &&
    sudo apt install git -y &&
    sudo apt install build-essential -y &&
    sudo apt install gcc-10 -y &&
    sudo apt install g++-10 -y &&
    # sudo apt install gcc-11 -y &&
    # sudo apt install g++-11 -y &&

    cd $HOME
    git clone https://github.com/aristocratos/btop.git $TEMP_BTOP
    cd $TEMP_BTOP
    sudo make CXX=g++-10 &&
    sudo make install &&
    btop --version

  }

  function installzathura() {
    sudo add-apt-repository ppa:spvkgn/zathura-mupdf -y
    sudo apt update -y
    sudo apt-get install zathura zathura-pdf-mupdf -y

  }

  function installcapybararelated() {
    sudo apt install g++ qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base \
      gstreamer1.0-tools gstreamer1.0-x -y

  }

  function installpostgresqlrelated() {
    sudo apt install postgresql -y &&
    sudo apt install pgadmin3 -y &&
    sudo apt install libpq-dev -y &&
    sudo apt install postgresql-server-dev-all -y

  }

  function installtaskwarriorrelated() {
    sudo apt install tasksh -y &&
    sudo apt install taskwarrior -y &&
    sudo apt install timewarrior -y &&
    gitinstalltaskwarrior

  }

  # TODO: How to make default browser for vim's ,b stuff?
  function installbrave() {
    # sudo snap install brave
    sudo apt install apt-transport-https curl -y &&
    curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update &&
    sudo apt install brave-browser -y &&

    # xdg-settings set default-web-browser brave-browser.desktop
    xdg-settings set default-web-browser brave.desktop

  }

  function installelinks() {
    sudo apt install elinks -y
    # cd ~/dotfiles
    # stow elinks

  }

  function fehrandom() {
    feh --randomize --bg-fill ~/dotfiles/wallpapers/.wallpapers --no-fehbg

  }

  function gitinstalltaskwarrior() {
    local version=${1:-2.6.0}
    # cd /usr/share
    # sudo git clone --recursive -b $version https://github.com/GothenburgBitFactory/taskwarrior.git taskwarriorgit
    # cd taskwarriorgit
    sudo git clone --recursive -b $version https://github.com/GothenburgBitFactory/taskwarrior.git \
      $TEMP_TASKWARRIOR
    cd $TEMP_TASKWARRIOR
    sudo cmake -DCMAKE_BUILD_TYPE=release . &&
    sudo make &&
    sudo make install &&

    task --version

  }

  function installfonts() {
    sudo apt install unifont -y &&
    sudo apt install fonts-powerline -y &&
    installjetbrainsmono &&

    cd $HOME/dotfiles
    sudo stow fonts -t /

    cachefonts
  }

  function installjetbrainsmono() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

  }

  # function installstow() {
  function stowall() {
    cd ~/dotfiles

    # Remove existing
    rm -rf ~/.profile && \
    # rm -rf ~/.config/lxterminal/lxterminal.conf && \
    rm -rf ~/.gitconfig && \
    rm -rf ~/.taskrc && \
    # rm -rf ~/.task/completed.data && \
    # rm -rf ~/.task/pending.data && \
      # NOTE: Previously had these enabled, noticed they were causing an erase to already present
      # histories. Where did they get pulled in? Are they ALWAYS going to be here at this time? When
      # might they be "empty" and need to be removed to "make room" for the stow?
    rm -rf ~/.viminfo && \

    stow elinks  &&
    stow git  &&
    stow imwheel  &&
    stow lxterminal  &&
    stow profile  &&
    stow reference  &&
    stow rvm  &&
    stow taskwarrior  &&
    stow tmux  &&
    stow tmuxp  &&
    stow vifm  &&
    stow vim  &&
    stow vimwiki  &&
    rm -rf ~/.Xresources &&
    stow xresources  &&
    stow zathura  &&
    stowtimewarrior

  }

  function stowtimewarrior() {
    sudo cp /usr/share/doc/timewarrior/ext/on-modify.timewarrior ~/.task/hooks/ &&
    sudo chmod +x ~/.task/hooks/on-modify.timewarrior &&
    task diagnostics

  }

  function installdwm() {
    # sudo apt install xorg libx11-dev libxft-dev libxinerama-dev xdm suckless-tools dmenu \
    #   virtualbox-guest-X11 virtualbox-guest-utils -y

    sudo apt install libc6 -y &&
    sudo apt install libfontconfig1 -y &&
    sudo apt install libx11-6 -y &&
    sudo apt install libxft2 -y &&
    sudo apt install libxinerama1 -y &&
    sudo apt install stterm -y &&
    sudo apt install suckless-tools -y &&
    sudo apt install x11-xserver-utils -y &&
    gitinstalldwm

  }

  function gitinstalldwm() {
    # cd /usr/share
    # sudo git clone git://git.suckless.org/dwm
    # cd dwm
    if [ ! -d "$TEMP_DWM" ]; then
      sudo git clone git://git.suckless.org/dwm $TEMP_DWM
    else
      cd $TEMP_DWM
      sudo git pull
    fi
    # sudo make
    # sudo rm -rf /usr/share/dwm/config.h
    # sudo ln -s ~/dotfiles/dwm/config.h /usr/share/dwm/config.h
    # NOTE: Recent install put DWM @ v6.3, which contained some differences in the default
    # config.def.h provided compared to the one I had saved in my dotfiles. So I'm going to try
    # using the default at first and see how that goes. It's been too long since I've worked with
    # patching, so I'll have to look into how to apply any .diff files I'll want to apply from the
    # dotfiles

    # sudo cp config.def.h config.h
      # NOTE: Going to use dotfiles config.h through the stow command

    stowdwmrelated &&
    # make clean install
    cd $TEMP_DWM
    sudo make &&
    sudo make install &&
    dwm -v

  }

  function stowdwmrelated() {
    cd $HOME/dotfiles
    sudo stow dwm -t /

  }

  function gitinstallsurf() {
    # NOTE: This requires libgtk-4-0 which, at the time of this writing, was not easily available
    # for the distro I'm using
    cd /usr/share
    sudo git clone git://git.suckless.org/surf surfgit
    cd surfgit
    sudo make clean install

  }

  # NOTE: You've since included the color scheme files as part of your vifm dotfiles repo, so they
  # should come ready to go. All you may want to do is run a git pull from within the directory to
  # check for updates
  # function gitinstallvifmcolors() {
  #   rm -rf ~/.vifm/colors
  #   git clone https://github.com/vifm/vifm-colors ~/.vifm/colors

  # }

  function installgvm() {
    sudo apt install bison -y &&
    bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    echo "source /home/$USERNAME/.gvm/scripts/gvm" >> ~/.bashrc && source ~/.bashrc
    gvm install go1.18.3
    gvm use go1.18.3 --default

  }

  function setupneovimlsp() {
    go install golang.org/x/tools/gopls@latest

  }

  function installvim() {
    sudo apt install clang -y && \
    sudo apt install libtool-bin -y && \
    sudo apt install golang -y && \
    installgvm
      # NOTE: Compiling from source takes a LONG time, perhaps there's a more efficient way?
    sudo apt install libatk1.0-dev -y && \
    sudo apt install libcairo2-dev -y && \
    sudo apt install libgtk2.0-dev -y && \
    sudo apt install libgtk-3-dev -y && \
    sudo apt install libncurses5-dev -y && \
    sudo apt install libncursesw5-dev -y && \
    sudo apt install libperl-dev -y && \
    sudo apt install libpython3-dev -y && \
    sudo apt install libx11-dev -y && \
    sudo apt install libxpm-dev -y && \
    sudo apt install libxt-dev -y && \
    sudo apt install libxtst-dev -y && \
    sudo apt install lua5.3 -y && \
    sudo apt install liblua5.3-dev -y && \
    sudo apt install luajit -y && \
    sudo apt install python-dev -y && \
    sudo apt install python3-dev -y && \
    sudo apt install python3-pip -y && \
    sudo apt install ruby-dev -y && \
    sudo apt install silversearcher-ag -y && \

    # FIXME: How can I only install the dependencies that come with these packages?
    sudo apt install vim-gtk -y && \
    sudo apt install vim-gtk3 -y && \
    sudo apt install vim-nox -y && \
      # lua5.3-dev \
      # libgnome2-dev \
      # libgnomeui-dev \
      # vim-gnome \

    npm install -g pnpm &&

    pnpm install -g fd-find &&

    sudo apt update &&

    pip3 install --upgrade setuptools &&
    pip3 install neovim &&
    pip3 install --user --upgrade pynvim &&
    pip3 install msgpack &&
    gitinstallvim
    # cd ~/.dotfiles
    # stow vim
    stowvim

  }

  function stowvim() {
    cd $HOME/dotfiles
    stow vim
  }

  function gitinstallvim() {
    sudo apt update &&
    if [ ! -d "$TEMP_VIM" ]; then
      sudo git clone https://github.com/vim/vim.git $TEMP_VIM
    else
      cd $TEMP_VIM
    fi
    gitvimconfigandmake | tee ~/gitinstallvim.log
      # NOTE: moved tee output to the `.config` command later down the line

  }

  function gitvimconfigandmake() {
    cd "$TEMP_VIM"
    sudo make clean &&
    sudo make distclean

    sudo ./configure --with-features=huge --enable-fail-if-missing --enable-cscope --enable-fontset --disable-gui --disable-netbeans --with-x --enable-multibyte --enable-largefile --enable-luainterp --enable-python3interp --with-python3-command=$(which python3) --with-python3-config-dir=$(python3-config --configdir) --enable-rubyinterp=dynamic --with-ruby-command=$(which ruby) 2>&1 | tee ~/gitvimconfigandmake.log

     # Pyenv {{{
     # NOTE: These various python3 related option commands were attempts to get vim to compile with
     # +python3 while using pyenv to manage the install. Needless to say, I couldn't ever get it to
     # work...
     # --enable-python3interp \
     # --enable-python3interp=dynamic \
     # --python3interp \
     # --python3-command=${PYTHON_CMD} \
     # --with-python3-command=$HOME/.pyenv/versions/3.11.0b3/bin/python3 \
     # --with-python3-command=$HOME/.pyenv/versions/3.11.0b3/bin/python3.11 \
     # --with-python3-command=python3 \
     # --with-python3-command=python3.11 \
     # TODO: How to make this refer to the 'active' Python version in pyenv? Maybe you could use
     # some form of the command `python3.11-config`?
     # --with-python3-config-dir=/usr/bin/python3-config \
     # --with-python3-config-dir=$HOME/.pyenv/versions/3.11.0b3/lib/python3.11/config-3.11-x86_64-linux-gnu \
     # --with-python3-config-dir=$HOME/.pyenv/versions/3.11.0b3/bin/python3.11-config \

     #}}}

    sudo make &&
    sudo make install &&
    \vim --version

  }

  function gitupdatevim() {
    # cd /usr/share/vim
    cd $TEMP_VIM
    sudo rm ./src/auto/config.cache -y &&
    sudo make clean distclean
    # sudo git pull --all
    sudo git pull
    # gitvimconfigandmake | tee ~/gitupdatevim_$(date -d "today" +"%Y%m%d%H%M%S").txt
    gitvimconfigandmake | tee ~/gitupdatevim.log

  }

  function installneovim() {
    sudo apt install autoconf -y &&
    sudo apt install automake -y &&
    sudo apt install doxygen -y &&
    sudo apt install g++ -y &&
    sudo apt install gettext -y &&
    sudo apt install golang -y && \
    sudo apt install libtool -y &&
    sudo apt install libtool-bin -y &&
    sudo apt install ninja-build -y &&
    sudo apt install pkg-config -y &&
    sudo apt install ripgrep -y &&
    sudo apt install unzip -y &&
    cargo install tree-sitter-cli &&
    pnpm install -g neovim &&
    gem install neovim &&

    installgvm
    setupneovimlsp

    gitinstallneovim | tee ~/installneovim.log

    cd ~/dotfiles
    stow neovim

    # QUESTION: Does this work?
    # sudo chown -R $(whoami) $(which nvim)
    sudo chown -R $(whoami) $HOME/.local/state/nvim

  }

  function gitinstallneovim() {
    if [ ! -d "$TEMP_NEOVIM" ]; then
      sudo git clone https://github.com/neovim/neovim.git $TEMP_NEOVIM
    else
      cd $TEMP_NEOVIM
      sudo git pull
    fi

    sudo make clean
    sudo make distclean

    # sudo make CMAKE_BUILD_TYPE=Release
    sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install

  }

  function gitupdateneovim() {
    cd $TEMP_NEOVIM 
    sudo make clean &&
    sudo make distclean &&
    sudo git pull &&
    sudo make CMAKE_BUILD_TYPE=RelWithDebInfo &&
    sudo make install &&
    \nvim --version

  }

  function gitupdatedwm() {
    cd $TEMP_DWM
    sudo git pull

    # sudo make clean install

    # make
    sudo make
    sudo make install
    dwm -v

  }

  function gitinstalllibvips() {
    sudo apt install build-essential -y &&
    sudo apt install libxml2-dev -y &&
    sudo apt install libfftw3-dev -y &&
    sudo apt install libmagickwand-dev -y &&
    sudo apt install libopenexr-dev -y &&
    sudo apt install liborc-0.4-0 -y &&
    sudo apt install gobject-introspection -y &&
    sudo apt install libgsf-1-dev -y &&
    sudo apt install libglib2.0-dev -y &&
    sudo apt install liborc-0.4-dev -y &&
    sudo apt install autoconf -y &&
    sudo apt install automake -y &&
    sudo apt install libtool -y &&
    sudo apt install swig -y &&
    sudo apt install gtk-doc-tools -y &&
    sudo apt install libgtk2.0-dev -y &&
    sudo apt install libgtk-3-dev -y &&
    sudo apt install flex -y &&
    sudo apt install bison -y &&

    # cd /usr/share
    # sudo git clone https://github.com/jcupitt/libvips.git libvipsgit
    # cd libvipsgit
    cd
    sudo git clone https://github.com/jcupitt/libvips.git $TEMP_LIBVIPS
    cd $TEMP_LIBVIPS
    sudo ./autogen.sh
    sudo ./configure
    sudo make install &&

    # cd /usr/share
    # sudo git clone https://github.com/jcupitt/nip2.git nip2git
    # cd nip2git
    cd
    sudo git clone https://github.com/jcupitt/nip2.git $TEMP_NIP2
    cd $TEMP_NIP2
    sudo ./autogen.sh
    sudo ./configure
    sudo make install &&

    vips -v
    nip2 -v

  }

  function gitupdatelibvips() {
    # cd /usr/share/libvipsgit
    cd $TEMP_LIBVIPS
    git pull
    sudo ./autogen.sh
    sudo ./configure
    sudo make install &&

    # cd /usr/share/nip2
    cd $TEMP_NIP2
    git pull --all
    sudo ./autogen.sh
    sudo ./configure
    sudo make install &&

    vips -v
    nip2 -v

  }

  # NOTE: This partially installs ly and ends on a 'test' run. If it works properly, then you
  # can move on to no 2
  function gitinstallly1() {
    sudo apt install build-essential libpam0g-dev libxcb-xkb-dev -y
    # cd /usr/share/
    # sudo git clone https://github.com/nullgemm/ly.git lygit
    # sudo git clone --recurse-submodules https://github.com/nullgemm/ly lygit
    # sudo git clone --recurse-submodules https://github.com/fairyglade/ly lygit
    # cd lygit
    if [ ! -d "$TEMP_LY" ]; then
      sudo git clone --recurse-submodules https://github.com/fairyglade/ly $TEMP_LY
    else
      cd $TEMP_LY
    fi
    # sudo make github
    sudo make
    sudo make run

  }

  function gitinstallly2() {
    # cd /usr/share/lygit
    cd $TEMP_LY
    sudo make install
    sudo systemctl enable ly.service -f

  }

# NOTE: This is meant to be run in the libwebp directory created from tarring the libwebp files,
# see reference file for detail
  function installwebp() {
    sudo apt install webp -y &&

    cd ~/Downloads
    wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz &&
    tar xvzf libwebp-1.1.0.tar.gz &&
    cd libwebp-1.1.0 &&
    ./autogen.sh &&
    ./configure &&
    sudo make install
        ./configure --enable-libwebpmux --enable-libwebpdemux --enable-libwebpdecoder &&
    dwebp -version
    cwebp -version
    vwebp -version

  }

  function installrvm1() {
    sudo apt install gpgv2 -y &&
    sudo apt install gnupg -y &&
    sudo apt install gnupg2 -y &&

    command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -

    \curl -sSL https://get.rvm.io | bash -s stable

  }

  function installrvm2() {
    source ~/.rvm/scripts/rvm &&
    rvm requirements &&
    rvm install ruby &&
    rvm use ruby --default &&
    rvm rubygems current &&
    gem install bundler --no-document &&
    gem install rails --no-document

  }

  function installrust() {
    curl https://sh.rustup.rs -sSf | sh &&
    rustup update stable

  }

  function installpywal() {
    pip3 install pywal &&
    pip3 install wpgtk &&
    sudo apt install python-gobject feh imagemagick -y

  }

  # NOTE: This has NOT been tested yet, so there may be some kinks to work out
  function setuplandapp() {
    sudo apt install qt5-default -y &&
    sudo apt --no-install-recommends install libqt*5-dev -y &&
    sudo apt --no-install-recommends install qt*5-dev -y &&
    sudo apt --no-install-recommends install qml-module-qtquick-* -y &&
    sudo apt --no-install-recommends install qt*5-doc-html -y &&
    installpostgresqlrelated &&
    installrvm1 &&
    installrvm2 &&
    installwebp &&
    gitinstalllibvips &&
    # installrust &&

    mkdir -p $HOME/Programming/Projects &&
    cd $HOME/Programming/Projects &&
    git clone git@bitbucket.org:BlakeLeBlanc/land_app.git

    cd ~/dotfiles
    sudo stow logrotate -t /

  }

  function pip3outdated() {
    pip3 list --outdated --format columns

  }

  function pip3updateall() {
    pip3 list outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U

  }

  function installpyenv() {
    # NOTE: This is done through pyenv-installer https://github.com/pyenv/pyenv-installer

    sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
    libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl &&

    curl https://pyenv.run | bash

  }

  function installmusikcube() {
    # sudo apt install cmake boost libogg vorbis ffmpeg ncurses zlib asound pulse libcurl \
    # libmicrohttpd libmp3lame libev4 libtag1-dev libopenmpt
    sudo apt install build-essential clang \
    libboost-thread1.67-dev libboost-system1.67-dev libboost-filesystem1.67-dev \
    libboost-date-time1.67-dev libboost-atomic1.67-dev libboost-chrono1.67-dev libogg-dev \
    libvorbis-dev libavutil-dev libavformat-dev libswresample-dev libncursesw5-dev libasound2-dev \
    libpulse-dev pulseaudio libmicrohttpd-dev libmp3lame-dev libcurl4-openssl-dev libev-dev \
    libssl-dev libtag1-dev libopenmpt-dev \
    -y

    cd $HOME
    git clone https://github.com/clangen/musikcube.git --recursive
    cd musikcube
    cmake -G "Unix Makefiles" .
    make
    sudo make install

  }

  function installluarelated() {
    curl -R -O

  }


# }}}

alias suspend="sudo systemctl suspend"
alias hibernate="sudo systemctl hibernate"

alias nnn='nnn -d -e -H -r'

# pomodoro and notification related aliases  {{{
  # pomo(time) {
  #   sleep "{time}" && zenity --warning --text="{time/60} minutes passed"
  # }

  pomo25() {
    sleep 1500 && zenity --warning --text="25 minutes have passed"
  }

  pomo50() {
    sleep 3000 && zenity --warning --text="50 minutes have passed"
  }

  pomo115() {
    sleep 4500 && zenity --warning --text="75 minutes have passed"
  }

  break5() {
    sleep 300 && zenity --warning --text="Your 5 minute break is up muchacho!"
  }

  break15() {
    sleep 900 && zenity --warning --text="Your 15 minute break is up muchacho!"
  }

  term5() {
    termdown 300 -b -v ENGLISH
  }

  term25() {
    termdown 1500 -b -v ENGLISH
  }

  term50() {
    termdown 3000 -b -v ENGLISH
  }

  term115() {
    termdown 4500 -b -v ENGLISH
  }

#}}}

# REISUO/REISUB {{{
  alias rsuo="cd /usr/local/bin && sudo rsuo.sh"
  alias rsub="cd /usr/local/bin && sudo rsub.sh"

#}}}

# start {{{
  alias start="cd dotfiles && git pull --all && tmuxp"

#}}}

# tmux {{{
  alias tmuxq="tmux kill-server"
  alias tq="tmux kill-server"

#}}}

# tmuxp {{{
alias landapp="cd ~/dotfiles && git pull --all && tmuxp load ~/.tmuxp/landapp.yaml"
# alias tithely="cd ~/dotfiles && git pull --all && tmuxp load ~/.tmuxp/tithely.yaml"
# alias expressjs="cd ~/dotfiles && git pull --all && tmuxp load ~/.tmuxp/expressjs.yaml"
# alias heyurl="cd ~/dotfiles && git pull --all && tmuxp load ~/.tmuxp/heyurl.yaml"

#}}}

# vim and nvim {{{
  # "smart" way to enter back into a previously backgrounded vim session (typically with <C-z>)
  alias vim="if jobs | grep -q vim; then fg; else command vim; fi"

  alias nvim='if jobs | grep -q nvim; then fg; else command nvim; fi'
  # alias nvim='if jobs | grep -q nvim; then fg; else command flatpak run io.neovim.nvim; fi'
#}}}

#virtualbox {{{
# alias mountvbox="sudo mount -t vboxsf 0_Books ~/Desktop/0_Books"

function mountvbox() {
  # sudo mkdir ~/Desktop/0_Books
  # sudo mount -t vboxsf 0_Books ~/Desktop/0_Books

  sudo adduser $USER vboxsf
  sudo usermod -a -G vboxsf $USER

}

#}}}

# vtop  {{{
  alias vtop="vtop --theme seti"

#}}}

# weather {{{
  # alias w="curl wttr.in?2QF"
  alias weather="curl wttr.in?F"
  alias weathergraph="curl v2.wttr.in?F"
  alias weathermap="curl v3.wttr.in?F"
  alias moon="curl wttr.in/moon?F"

  alias edmond="curl wttr.in/73003?F"
  alias edmondgraph="curl v2.wttr.in/73003?F"
  alias edmondmap="curl v3.wttr.in/73003?F"
  # alias edmondmoon="curl wttr.in/moon_73003?F"

#}}}

# xterm {{{
  # alias xres="xrdb -merge ~/.Xresources"
  alias xres="xrdb ~/.Xresources"

#}}}

alias sv="ssh-add ~/.ssh/virtual"
alias sl="ssh-add ~/.ssh/laptop"
alias j="jobs"

# color support of ls {{{
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls -la --color=auto"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF --color=auto'
alias la='ls -A'
alias l='ls -CF'

#}}}

