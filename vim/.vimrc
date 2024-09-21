" https://www.youtube.com/playlist?list=PLhoH5vyxr6Qq41NFL4GvhFp-WLd5xzIzZ

" Strongly advised these be the first lines
set nocompatible
"   UPDATE: Actually, the nocompatible thing may not be needed after all. Evidently if you include
"   a custom .vimrc file, the nocompatible setting is assumed by vim automatically.
"     https://www.reddit.com/r/vim/wiki/vimrctips
set encoding=utf-8

"vim-plug {{{
"commands --------------------
":PlugInstall
":PlugUpdate
":PlugClean " remove unused directories
":PlugUpgrade " upgrade vim-plug itself
":PlugStatus
":PlugDiff " view changes from previous update
"NOTE: If it is hanging and taking forever, limit it to one thread by addding 1
"  :PlugInstall 1

" vim {{{
if !has('nvim')
"setup {{{
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    augroup PlugVim
      autocmd!
      autocmd VimEnter * PlugInstall | source $MYVIMRC
    augroup end
  endif

  "If not, then run the following command in the terminal:
  " curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " Launch vim, <CR> through any complaints, then run :PlugInstall

"  "...If not, then run the following command in the terminal:
"  " curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  " Launch nvim, <CR> through any complaints, then run :PlugInstall

"  " flatpak
"  " if empty(glob('~/.var/app/io.neovim.nvim/data/nvim/site/autoload/plug.vim'))
"  "   silent execute "curl -fLo ~/.var/app/io.neovim.nvim/data/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

"  "   augroup PlugNeovim
"  "     autocmd!
"  "     autocmd VimEnter * PlugInstall | source $MYVIMRC
"  "   augroup END
"  " endif
"endif

"}}}

"Plugins ---------------------{{{
  call plug#begin()

  " unsorted {{{
  " NOTE: Troubleshooting some sluggishness that creeps into vim from time to time. Disabled virtually
  " all plugins, will re-enable one by one to try and weed out the culprit. Prior activated plugins
  " are prefixed by `!ON!` so you can easily search them

  Plug 'AndrewRadev/linediff.vim'
  Plug 'andymass/vim-matchup'
  " NOTE: adds more jump-to symbols to vim, alternative to matchit
  " Plug 'blueyed/vim-diminactive' " Not quite what you're after, it only colors the background,
  " doesn't actually dim
  Plug 'brianrodri/vim-sort-folds'
    " NOTE: does NOT seem to work with manual folds, unfortunately. Though I could have SWORN it
    " worked before...
    " UPDATE: Working again! I suspect it also had something to do with the lexima plugin. Disable
    " that bad boy and go :)
  " Plug 'christoomey/vim-sort-motion'
  " Plug 'christoomey/vim-system-copy' " adds vim operator + motion commands for copying into/from
  " system clipboard
  Plug 'dkarter/bullets.vim'
  " Plug 'dbeniamine/cheat.sh-vim'
  Plug 'farmergreg/vim-lastplace' " repoen files at last edit position
  " Plug 'gillyb/stable-windows'
    " NOTE: Doesn't seem to play well with switching panes, maybe because of how I have vim tied into
    " tmux?
  " Plug 'itchyny/calendar.vim' " an amazing calendar plugin, can sync with google if wanted
    " NOTE: At this time, I'm using taskwarrior instead. If only it could sync with taskwarrior data!
  " Plug 'gcavallanti/vim-noscrollbar' " provides visual representation of where you're at in the file
  Plug 'habamax/vim-asciidoctor'
  Plug 'janko-m/vim-test' " useful shortcuts for easily running tests
  Plug 'junegunn/goyo.vim', { 'on': 'Goyo'} " distraction-free writing
  " Plug 'junegunn/limelight.vim' " distraction-free writing
  " Plug 'matze/vim-move' " 'visually' move lines throughout code, auto-indenting as it goes along
  " Plug 'mkitt/tabline.vim' " custom tabline
  " Plug 'nathanaelkane/vim-indent-guides' " adds visual colors to indent levels
  " Plug 'mhinz/vim-startify' # adds a customizable start-screen to vim
  " Plug 'nathanaelkane/vim-indent-guides' , { 'on': 'IndentGuidesToggle' } " add indent level colors
  Plug 'pechorin/any-jump.vim', { 'on': 'AnyJump' }
    " NOTE: In order to get this to work, I had to clean up some search engine stuff. Because I had
    " 'ag' installed, but I also had a 'rg' (ie ripgrep) installed from a loooong time ago. And
    " I think that rg install never really went well (which is why I never really used it). So the
    " 'fix' was to simply remove rg altogether and only have ag installed on the OS
  Plug 'reedes/vim-pencil' " styling and formatting stuff for writing
  " Plug 'shougo/unite.vim' " search and display info from arbitrary files
  "   NOTE: unite is no longer supported, has since moved to a new plugin called denite
  "   Plug 'shougo/denite.vim' " search and display info from arbitrary files
  " Plug 'skamsie/vim-lineletters'
  " Plug 'soywod/kronos.vim' " Not quite as feature complete as Taskwarrior, but maybe one day? The
  "   interface is really slick
  " Plug 'sts10/vim-zipper' " vim already has ~6 ways to fold, but this may make it a bit more
  "   user-friendly (??)
  " Plug 'swordguin/vim-veil' ", { 'on': '<Plug>Veil' } covers-up text while writing so you're not
  "   tempted to edit or change things
  " Plug 'takac/vim-hardtime' " adds a timeout on hjkl key presses to help break bad habits
  "   NOTE: While a good idea on paper, in practice I found it excrutiating. Sure, it helped expose
  "   some questionable inline habits, but it would also trigger on relative movements as well and
  "   that was just too much.
  " Plug 'TaDaa/vimade' " adds a dimming effect to inactive buffers currently in view, similar to goyo
  "   without isolating
  " NOTE: When enabled with gitgutter or vim-signify, causes an odd colorscheme glitch when leaving
  " goyo mode. Have been in contact with the developer, if he's able to get it sorted out, I'll
  " consider enabling it again
  " Plug 'terryma/vim-multiple-cursors' " default keymap is CTRL+N
  Plug 'thaerkh/vim-workspace' " automated session management and file auto-save
  " Plug 'tpope/vim-bundler'
  Plug 'tpope/vim-rails' " gives some navigation features between rails files
    " NOTE: Required for erb tags to work with vim-surround, Insert mode <C-S>-/=
    " NOTE: Also, perhaps more importantly, vim-rails also provides a :Ctags command, requires `$ sudo
    " apt install exuberant-ctags` to be installed. Perhaps this is a way to get ctags to work in
    " ruby/rails environment?
    " See `:h " rails-:Ctags`
  Plug 'tpope/vim-repeat'
  " Plug 'tpope/vim-unimpaired' " adds a bunch of shortcut commands
  "   NOTE: I don't particularly find many of them useful at this time, also conflicts with [t/]t for
  "   tab switching
  Plug 'vim-scripts/fountain.vim'
    " NOTE: Adds fountain syntax highlights
  " Plug 'valloric/matchtagalways' " highlights matching xml/html tags
  " Plug 'voldikss/vim-floaterm'

  "}}}

  "animated scrolling {{{
  " NOTE: So far, vim-smoothie is the best I've tried, but even then it introduces some noticeable
  " hiccups and stuff. You know that lagginess and unresponsiveness you experience from time to time
  " when it comes to changes lines and stuff? Well, all of those same issues are encountered with
  " animated scrolling. Which is so weird... I'm still not sure what's causing that
  " unresponsiveness...
  " Plug 'psliwka/vim-smoothie'
  " Plug 'yuttie/comfortable-motion.vim' " adds an animated scrolling effect

  "}}}

  "asyncronous command engines -{{{
  " Plug 'idbrise/asynccommand'
  " Plug 'skywind3000/asyncrun.vim' " Alternative to vim-dispatch
  " Plug 'tpope/vim-dispatch' " Asyncronously runs various commands in the background, outputting any
  " error results, etc. It can even link up with tmux and do all of its stuff in a wholly separate
  " tmux window/pane then when complete, output the results in vim quickfix/whatever window. Very
  " cool! Though I'm not sure how I can take advantage of it right now...

  "}}}

  "auto-close tags -------------{{{
    " for brackets, parens, quotes, etc
      " Plug 'cohama/lexima.vim'
        " NOTE: May likely become the new go-to! Does pair matching as well as do end/etc
        " matching. Very cool! If you ever find that you'd like to run endwise separately, you can
        " disable that functionality and run 'just' the pairing portion of the plugin
        " UPDATE: While I generally liked the lexima plugin, it conflicts with plugins that rely on
        " the popup menu. Most notably, this comes into play with code completion plugins like
        " VimCompletesMe or Deoplete, etc. Basically, it causes the use of <CR> in making the popup
        " selection to ALSO insert a new line. There are supposedly workarounds for this as I've
        " noted in its config section, but I haven't been able to get them to work
      Plug 'jiangmiao/auto-pairs' " for brackets, parens, quotes, etc
        " NOTE: Long time reigning champ for what I've been using
      " Plug 'raimondi/delimitmate' " Conflicts with vim-closetag
      " Plug 'tmsvg/pear-tree' " for brackets, parens, quotes, etc
        " NOTE: Good, but seems to conflict with tpope's endwise, which is a dealbreaker for me
        " https://github.com/tmsvg/pear-tree/issues/33
        " https://github.com/tmsvg/pear-tree/issues/47
        " https://github.com/tmsvg/pear-tree/issues/48
      " Plug 'townk/vim-autoclose' " last update 20120929
      " Plug 'vim-scripts/ClosePairs' " last update 20080909. I'm wanting to say this is what I was
      "   using before since it played well with the journal.md's use of * [ ]. Maybe there's a way
      "   I can tweak vim-closetag above so it doesn't add those extra spaces as padding inside the
      "   brackets?

    " for tag pairs, ie <table> </table>
      Plug 'alvan/vim-closetag'

    " Plug 'machakann/vim-sandwich' " alternative to vim-surround
    Plug 'tpope/vim-surround' " Notes on how to use it in the Plugin Settings section below

  "}}}

  "browser related -------------{{{
  " Plug 'MikeCoder/open-in-browser.vim' " opens current html/etc file in a browser window
  "   UPDATE: This plugin is no longer hosted on github
  "   NOTE: Same thing can be accomplished with pure vim?
  "   See http://vim.wikia.com/wiki/Preview_current_HTML_file
  Plug 'tyru/open-browser.vim', { 'on' : '<Plug>(openbrowser-open)' }
  "   UPDATE: This functionality is built into vim  with the use of `gx`, though it can run into some
  "   conflicts with certain browsers. To fix this, some users modify the command with the following:
  "     nnoremap gx :execute 'silient! !xdg-open "<cfile>" &> /dev/null &' <bar> redraw! <CR>
    " NOTE: also recommended `$ sudo apt install libatk-adaptor libgail-common`

  "}}}

  "c# {{{
  " Plug 'OmniSharp/omnisharp-vim' " provides code completion/popup type stuff for C#

  "}}}

  "code completion -------------{{{
  " UPDATE: Something else you may get some use of out at some point is to let vim rock and roll
  " with an LSP server. This allows for a kind of 'smart' autocomplete setup that takes advantage of
  " Microsoft's own Languange Server Protocol through the use of a Language Server Client (LSC)
  "
  "   https://bluz71.github.io/2019/10/16/lsp-in-vim-with-the-lsc-plugin.html
  "
  " UPDATE: From a reddit thread. Turns out lsp can be used for much more than just code completion,
  " also for displaying definitions, etc
  " https://old.reddit.com/r/vim/comments/v8j1cg/where_to_start_with_lsp_in_vim/
  "   https://langserver.org
  "   https://github.com/natebosch/vim-lsc
  "   https://github.com/prabirshrestha/vim-lsp
  "   https://github.com/autozimu/LanguageClient-neovim (supports vim & neovim)
  "   https://github.com/w0rp/ale
  "   https://github.com/neoclide/coc.nvim

  "   Most plugins will require you to do add some configuration to wire up the Language Server
  "   client (i.e. the plugin) with the language server (e.g. pyright, pylsp, ...etc).

  "   ALE is a bit different in that users typically don't need to wire up anything. Just install
  "   ALE & install language servers and/or linters in your $PATH and ALE will detect and run all
  "   available linters/LSPs when you open the corresponding filetype (e.g. file.py).

  "   Other than that, I recommend reading plugin docs to learn how to use/configure the plugin with
  "   the language server and ask for help on the github repo if you have specific questions or run
  "   into issues/errors.
  "
  " UPDATE: I added a custom setup for omnicomplete that allows vim to trigger it on the <tab>
  " key. Very cool! May be good enough for me for how I find myself using (or, should I say, NOT
  " using) the deoplete plugin very often in a session.
  "
  " NOTE: Okay so a quick word on this... The main issue I run into with these plugins is that, over
  " time, they seem to slow down the responsiveness of vim. I assume because it's churning stuff in
  " the background while you type. To remedy this to some extent, I've made deoplete and completor
  " trigger manually rather than their default automatically. This has seemed to help, but there's
  " still a slight drag.
  " Of the two, completor does seem to be more responsive, though I'm not sure if I care for how it
  " handles certain things related to HOW a selection is made and how things get inserted. So from
  " a usability standpoint deoplete still takes the cake in my experience and is the preferred
  " solution.
  " For these reasons, I still wonder if the benefits are worth it. Given how I currently use them,
  " are they *that* much more powerful than vim's built-in omnicomplete? Because disabling these
  " plugins altogether and running just the stock omni-complete is, no doubt, the fastest and most
  " responsive. The only time I really 'notice' anything is that omni seems to build its results on
  " the fly, rather than building the list in the background. I imagine this is one of the reasons
  " why it keeps vim so snappy though...
  "
  " NOTE: While researching a fix or alternative solution, I came across some interesting things
  " related to supercharging vim's own built in omni-complete tool. For example, my link below for
  " something called eclim supposedly allows for the IDE-like code completion fanciness of Eclipse
  " to run inside Vim by way of a secondary eclipse server that you run alongside your vim
  " instance. Could be very cool!
  "
  " https://stackoverflow.com/a/2196099
  " https://www.reddit.com/r/vim/comments/71nj1a/code_completion/dncsca7
  " http://www.belchak.com/2011/01/31/code-completion-for-python-and-django-in-vim/
  " http://eclim.org/index.html
  "   https://www.youtube.com/watch?v=B9P8r620BMY
  " https://github.com/prabirshrestha/asyncomplete-lsp.vim
  " https://github.com/prabirshrestha/vim-lsp
  "
  " Omnicomplete
  " NOTE: If you decide to rock a plugin solution, be sure you disable this section
  " function! Tab_or_Complete() abort
  "   if pumvisible()
  "     return "\<C-n>"
  "   elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
  "     return "\<C-p>"
  "   else
  "     return "\<Tab>"
  " endfunction
  " " Tab and Shift-Tab cycle through results
  " inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " inoremap <expr> <Tab> Tab_or_Complete()

  " Plug 'ajh17/VimCompletesMe' " super lightweight and minimal, utilizes vim's own built-in tools

  " Plug 'j5shi/CommandlineComplete.vim' " allows autocompletion within vim's commandline mode
    " NOTE: Though I gotta say, I'm not a fan of the extra keybindings for it to fire... I wonder,
    " is it possible to set this up similar to how I currently do the whole tab_or_complete thing?
    " UPDATE: It also sounds like you can achieve something very similar through the use of bash's
    " own built-in ctrl-R

  " Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}
    " UPDATE: This plugin requires vim 8.1, as of 20181117, Lubuntu/apt is still on vim 8.0x
    " NOTE: This plugin requires you to run a few extra commands in vim after you've installed it in
    " order to set up the languages/syntaxes you'd like for it to use. The following sets it up for
    " use with json, html, css, and javascript :CocInstall coc-json coc-html coc-css coc-tsserver

  " Plug 'prabirshrestha/asyncomplete.vim'

  Plug 'shougo/ddc.vim'
    " $ cargo install deno --locked
    " $ deno run https://deno.land/std/examples/welcome.ts
    Plug 'vim-denops/denops.vim'
    " Plug 'vim-denops/denops-helloworld.vim'
      " NOTE: Can be disabled once confirmed in vim with `:HelloDenops`
    Plug 'shougo/ddc-around'
    Plug 'shougo/ddc-matcher_head'
    Plug 'shougo/ddc-sorter_rank'
  " Plug 'shougo/deoplete.nvim'
    " NOTE: deoplete has since been deprecated, ddc is the latest :)
    " NOTE: Enable <Tab> keybinding in plugin settings, and enable 'call' for custom settings
    " vim 8+ version of neocomplete, requires the following + uncomment the Plugs included below:
    " Plug 'ternjs/tern_for_vim', { 'do': 'pnpm install' }
    " Plug 'roxma/nvim-yarp'
    " Plug 'roxma/vim-hug-neovim-rpc'
    "   $ sudo apt install python3-pip
    "     NOTE: In pacman, this is simply python-pip
    "   $ pip3 install --upgrade setuptools
    "   $ pip3 install neovim
    "   $ pip3 install --user --upgrade pynvim
    "   $ pip3 install msgpack
    "
    " Optional plugins for deoplete:
    " Plug 'deoplete-plugins/deoplete-tag' " will include tag files in its source search

  " Plug 'shougo/neocomplete.vim' " alternative to YouCompleteMe, found it easier to install. Since
  "   VIM 8's release, the plugin is no longer being actively developed outside of bug fixes. Author
  "   recommends moving to his newer Plugin deoplete. HOWEVER! If you do find deoplete to be a bit
  "   finicky or something, neocomplete does still work well

  " Plug 'maralla/completor.vim', { 'dir': '~/.vim/plugged/completor.vim', 'do': 'make js' }
    " NOTE: Enable <Tab> keybinding in plugin settings
    " NOTE: This is an async completion pop-up plugin built specifically for vim 8+, different than
    " deoplete which, while it does work well, was designed around neovim (and others?) first and
    " vim second
    " Plug 'ternjs/tern_for_vim', { 'do': 'pnpm install' }
    " Plug 'ferreum/completor-tmux'

  Plug 'tpope/vim-endwise' " adds end when starting a block
    " NOTE: Great plugin! But I've found lexima takes cares of both THIS and paren/etc pair matching
    " all in one go
  " Plug 'wellle/tmux-complete.vim' " adds code completion between visible tmux-panes

  "}}}

  "code formatters -------------{{{
  " Plug 'prettier/vim-prettier', { 'do': 'yarn install', 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql'] }
    " NOTE: Before you can use the plugin, you need to also have the prettier node package installed
    " In the project's root directory, type:
      " $ npm install prettier --save

  " Plug 'ngmy/vim-rubocop' " allows rubocop to be ran within vim and displays results
    " UPDATE: For some reason, after install, I get the message 'Not an editor command: Rubocop'

  "}}}

  "color value highlights ------{{{
  " UPDATE: Sounds like vim-hexokinase may perform a lot better than the others, though it doesn't
  " seem to work with vim 8.0
  " NOTE: Okay, so unfortunately, every single one of these I've tried tends to really bog down
  " vim's performance. Evidently it will run through all files, not just css/scss related files. So,
  " for example, whenever it gets really sluggish, if I run a :profile, it will show significant
  " processing on its related operations. Special thanks to Andy from gitgutter for helping me sort
  " this out!

  " Plug 'ap/vim-css-color'
  " Plug 'chrisbra/colorizer'
  " Plug 'gko/vim-coloresque'
  "   NOTE: Combines vim-css-color and colorizer into one
  " Plug 'gorodinskiy/vim-coloresque'
  " Plug 'lilydjwg/colorizer'
  Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
  "   NOTE: requires golang to be installed `$ sudo apt install golang`
  "   After installed
  "     $ cd ~/.vim/plugged/vim-hexokinase # navigate to plugin's install directory
  "     $ make hexokinase
  "` Plug 'skammer/vim-css-color'

  "}}}

  "colorschemes ----------------{{{
  "http://colorswat.ch
  "http://vimcolors.com
  "https://vimcolorschemes.com

  " Plug 'zefei/vim-colortuner'
  "   NOTE: not compatible with terminal vim

  " Plug 'aditya-azad/candle-grey'
  Plug 'ajgrf/parchment'
  Plug 'ajh17/spacegray.vim'
  " Plug 'https://gitlab.com/aimebertrand/timu-spacegrey.git'
  " Plug 'AlessandroYorba/Alduin'
    " NOTE: Nice, but maybe a *slightly* bit too high contrast
  " Plug 'AlessandroYorba/Despacio'
  " Plug 'AlessandroYorba/Sierra'
  Plug 'altercation/vim-colors-solarized'
  Plug 'andreypopp/vim-colors-plain'
  Plug 'arcticicestudio/nord-vim'
  Plug 'arzg/vim-substrata'
  " Plug 'axvr/photon.vim'
  Plug 'ayu-theme/ayu-vim'
  " Plug 'baeuml/summerfruit256.vim'
  Plug 'barlog-m/oceanic-primal-vim'
  " Plug 'bluz71/vim-nightfly-guicolors'
  " Plug 'bluz71/vim-moonfly-colors'
  " Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
  " Plug 'chriskempson/base16-vim'
  Plug 'cideM/yui'
  Plug 'clinstid/eink.vim'
  " Plug 'cocopon/iceberg.vim'
  " Plug 'cocopon/lightline-hybrid.vim'
  " Plug 'co1ncidence/mountaineer.vim'
  "   NOTE: user got banned from github
  Plug 'danishprakash/vim-yami'
  Plug 'davidosomething/vim-colors-meh'
  " Plug 'desmap/slick'
  Plug 'deviantfero/wpgtk.vim'
  Plug 'dikiaap/minimalist'
  " Plug 'dracula/vim'
  " Plug 'drewtempelmeyer/palenight.vim'
  " Plug 'duckwork/nirvana'
  " Plug 'duckwork/low.vim'
  " Plug 'dylanaraps/wal.vim'
  " Plug 'easysid/mod8.vim'
  " Plug 'felipec/vim-felipec'
  " Plug 'habamax/vim-polar'
  Plug 'habamax/vim-alchemist'
  Plug 'hardselius/warlock'
  " Plug 'Haron-Prime/Antares'
  " Plug 'hhff/SpacegrayEighties.vim'
  " Plug 'jaredgorski/spacecamp'
  Plug 'jaredgorski/fogbell.vim'
  Plug 'JaySandhu/xcode-vim'
  " Plug 'Jorengarenar/vim-colors-B_W'
  " Plug 'joshdick/onedark.vim'
  " Plug 'jnurmine/Zenburn'
  Plug 'kaicataldo/material.vim', { 'branch': 'main' }
  " Plug 'KeitaNakamura/neodark.vim'
  " Plug 'keith/parsec.vim'
  Plug 'karoliskoncevicius/distilled-vim'
  " Plug 'karoliskoncevicius/sacredforest-vim'
  Plug 'kristijanhusak/vim-hybrid-material'
  Plug 'lifepillar/vim-solarized8' " optimized version of solarized
  Plug 'logico/typewriter-vim'
  Plug 'Lokaltog/vim-monotone'
  " Plug 'mhartington/oceanic-next'
  " Plug 'morhetz/gruvbox'
    Plug 'gruvbox-community/gruvbox'
    " NOTE: This forked repo is meant to be better maintained than the original
    Plug 'habamax/vim-gruvbit' " slightly different colorings here and there
    Plug 'lifepillar/vim-gruvbox8' " an optimized take on gruvbox
    Plug 'sainnhe/gruvbox-material'
    " NOTE: modified gruvbox theme to soften some contrasts and better eliminate blue-light colors
  " Plug 'mountain-theme/Mountain'
  Plug 'pradyungn/Mountain', {'rtp': 'vim'}
  Plug 'mswift42/vim-themes'
  " Plug 'nanotech/jellybeans.vim'
  " Plug 'nightsense/snow'
  Plug 'NLKNguyen/papercolor-theme'
  " Plug 'ntk148v/vim-horizon'
  Plug 'olivertaylor/vacme'
  " Plug 'overcache/NeoSolarized'
  " Plug 'patstockwell/vim-monokai-tasty'
  Plug 'pbrisbin/vim-colors-off'
  Plug 'pgdouyon/vim-yin-yang'
  " Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
  " Plug 'rakr/vim-one'
  Plug 'rakr/vim-two-firewatch'
  " Plug 'rj-white/vim-colors-paramountblue'
  " Plug 'https://gitlab.com/rj-white/waterfall.vim'
  " Plug 'rhysd/vim-color-spring-night'
  " Plug 'romainl/flattened'
  " Plug 'sainnhe/forest-night'
  Plug 'smallwat3r/vim-simplicity'
  " Plug 'sonph/onehalf'
  " Plug 'steveno/mavi'
  Plug 'stefanvanburen/rams.vim'
  " Plug 't184256/vim-boring'
  Plug 'therubymug/vim-pyte'
  " Plug 'tomasr/molokai'
  " Plug 'trevordmiller/nova-vim'
  Plug 'tyrannicaltoucan/vim-quantum'
  " Plug 'vim-scripts/Blueshift'
  " Plug 'vim-scripts/EditPlus'
  " Plug 'wadackel/vim-dogrun'
  " Plug 'w0ng/vim-hybrid'
  Plug 'YorickPeterse/vim-paper'
  " Plug 'zekzekus/menguless'

  " Yay but nay, for various reasons.
  " Plug 'godlygeek/csapprox' " helps properly display theme colors, including backgrounds
  " Plug 'andreasvc/vim-256noir'
  " Plug 'atelierbram/Base2Tone-vim'
  " Plug 'axvr/photon.vim'
  " Plug 'badacadabra/vim-archery'
  " Plug 'ciaranm/inkpot'
  " Plug 'dikiaap/minimalist'
  " Plug 'doums/darcula'
  " Plug 'fenetikm/falcon'
  " Plug 'flrnprz/candid.vim'
  " Plug 'https://gitlab.com/ducktape/monotone-termnial.git'
  " Plug 'hardcoreplayers/oceanic-material'
  " Plug 'huyvohcmc/atlas.vim'
  " Plug 'endel/vim-github-colorscheme'
  " Plug 'ewilazarus/preto'
  " Plug 'flazz/vim-colorschemes' " A collection with a TON of colorschemes
  " Plug 'fxn/vim-monochrome'
  " Plug 'gilgigilgil/anderson.vim'
  " Plug 'gosukiwi/vim-atom-dark'
  " Plug 'jacoborus/tender.vim'
  " Plug 'jonathanfilip/vim-lucius'
  " Plug 'junegunn/seoul256.vim'
  " Plug 'KimNorgaard/vim-frign'
  " Plug 'KKPMW/oldbook-vim'
  " Plug 'lifepillar/vim-wwdc16-theme'
  " Plug 'Lokaltog/vim-distinguished'
  " Plug 'LuRsT/austere.vim'
  " Plug 'marcopaganini/termschool-vim-theme'
  " Plug 'mhinz/vim-janah'
  " Plug 'nightsense/carbonized'
  " Plug 'noahfrederick/vim-hemisu'
  " Plug 'owickstrom/vim-colors-paramount'
  " Plug 'quanganhdo/grb256'
  " Plug 'reedes/vim-colors-pencil'
  " Plug 'reedes/vim-thematic'
  Plug 'robertmeta/nofrils'
  " Plug 'romainl/Apprentice'
  " Plug 'shinchu/lightline-gruvbox.vim'
  " Plug 'sjl/badwolf'
  " Plug 'smallwat3r/vim-efficient'
  " Plug 'smallwat3r/vim-simplicity'
  " Plug 'szorfein/fantasy.vim'
  " Plug 't184256/vim-boring'
  " Plug 'tpope/vim-vividchalk'
  " Plug 'tyrannicaltoucan/vim-deep-space'
  " Plug 'vim-scripts/The-Vim-Gardener'
  " Plug 'vim-scripts/256-grayvim'
  " Plug 'xero/blaquemagick.vim'
  " Plug 'xstrex/FireCode.vim'
  " Plug 'YorickPeterse/happy_hacking.vim'
  " Plug 'zefei/simple-dark'

  "}}}

  " comments -------------------{{{
  " Plug 'tomtom/tcomment_vim'
  Plug 'tpope/vim-commentary' ", { 'on': '<Plug>Commentary' }

  "}}}

  "ctags -----------------------{{{
  " NOTE: From what I can tell, ctags/cscope does not support Ruby/Rails or Javascript. There are some
  " alternatives out there though that might do the trick, including the starscope ruby gem or eclim.
  " UPDATE: Yep, just tried going through the motions again and and it doesn't seem to play well with
  " the tags file that results. So I'm just going to chalk it up to 'does not work' with
  " Ruby/Rails/JS. But perhaps the vim-rails plugin is able to fake a similar ability? And of course,
  " all that said, maybe developing in a Rails environment doesn't really NEED ctags like it might be
  " for other languages/frameworks? Because Rails does seem to be relatively self-contained and well
  " organized from the getgo. Maybe ctags isn't going to add much anyway?

  " Plug 'craigemery/vim-autotag'
  " Plug 'ludovicchabant/vim-gutentags'
  "   From what I've read, this seems to be head and shoulders above the others listed here.
  "   Recommended to use with
      " Plug 'skywind3000/gutentags_plus'
  " Plug 'majutsushi/tagbar' " requires universal-ctags/ctags
  "   NOTE: Not able to get tagbar to work. May have something to do with ctags, but I don't want to
  "   mess with it right now
  " Plug 'szw/vim-tags'
  "   NOTE: requires $ sudo apt install exuberant-ctags
  " Plug 'universal-ctags/ctags' " required for tagbar to work

  "}}}

  "database related tools ------{{{
  " Plug 'tpope/vim-dadbod'

  "}}}

  "factory_bot -----------------{{{
  " Plug 'christoomey/vim-rfactory'

  "}}}

  "git related {{{
  " Plug 'christoomey/vim-conflicted' " resolve git merge conflicts
  " Plug 'junegunn/gv.vim' " adds a blame-like line-by-line history view
  "   NOTE: requires vim-fugitive
  " Plug 'tommcdo/vim-fubitive' " Adds Bitbucket support for vim-fugitive's :Gbrowse command
  " Plug 'tpope/vim-fugitive' " Adds some git functionality to vim with commands like :Gstatus, etc.
  " UPDATE: Tried it again, and I just don't care for it. I really like th readibility of my terminal
  " git setup. It's also much more responsive, fugitive can be a little laggy when building the :Glog
  " output, for example.
  " UPDATE: Also, evidently vim-fugitive makes it easier to save git difftool changes directly to the
  " live files rather than git's default approach of working solely with tmp files
  " NOTE: for some reason, vim-sensible seems to be required in order for the :Gdiff command to work
  " Plug 'tpope/vim-sensible' " I think I have most of what I like here already manually implemented.

  "}}}

  "gutter additions ------------{{{
  Plug 'airblade/vim-gitgutter' " display git notations gutter
  "   NOTE: I friggin LOVE this plugin but form some reason, there are times when it *really really*
  "   starts to bog down performance. Like, so much so that there is a noticeable delay while
  "   typing. Whenever that happens, I've found that completely removing and reinstalling the plugin
  "   can help
  " Plug 'kshenoy/vim-signature' " display active marks in gutter
  "   NOTE: This is an excellent plugin, but there's one huge problem... In my experience, it causes
  "   vim to noticeably lag while scrolling. Which is a shame because I find it very helpful!
  "   An alternative to checkout is Yilin-Yang/vim-markbar
        " Plug 'Yilin-Yang/vim-markbar'
          " NOTE: If running < 8.1.0039, you'll need the following
          " Plug 'Yilin-Yang/vim-markbar', { 'branch': 'typevim' }
          " Plug 'Yilin-Yang/TypeVim'
          " Plug 'google/vim-maktaba'
  " Plug 'mhinz/vim-signify' " alternative to vim-gitgutter, though I prefer the gitgutter symbology

  "}}}

  "linters ---------------------{{{
  " Plug 'vim-syntastic/syntastic'

  " Plug 'dense-analysis/ale' " its big plus over syntastic is that it's ansyncronous
  "   UPDATE: Nope, still running into issues after global install of modules
  "     $ nvm install -g jshint
  "     $ nvm install -g eslint

  " Plug 'desmap/ale-sensible' | Plug 'dense-analysis/ale'
    " $ sudo npm i -D prettier standard

  " Plug 'maximbaz/lightline-ale' " lightline plugin for ale

  "}}}

  "markdown preview ------------{{{
  " Plug 'suan/vim-instant-markdown' " opens a browser window showing 'live' updates
  " NOTE: Must also install the following `$ sudo npm -g install instant-markdown-d`

  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

  "}}}

  "mergetool -------------------{{{
  Plug 'https://github.com/whiteinge/diffconflicts'
    " provides a two way diff view along with the traditional three way vimdiff
    " NOTE: Also requires the following edits be added to .gitconfig:
    " NOTE: the leading \ in front of the add'l double quotes in line two should not be typed, they're
    " only here to keep the .vimrc comments in check
    "   UPDATE: below added to dotfiles
    "   $ git config --global merge.tool diffconflicts
    "   $ git config --global mergetool.diffconflicts.cmd 'vim -c DiffConflicts \"$MERGED" \"$BASE" \"$LOCAL \"$REMOTE"'
    "   $ git config --global mergetool.diffconflicts.trustExitCode true
    "   $ git config --global mergetool.keepBackup false

  " Plug 'samoshkin/vim-mergetool' " this is kind of like diffconflicts on steroids with more
  " configuration options, etc. It's main bread and butter is that it allows for an accept-all from
  " remote or local without moving through each difference manually. This is kind of similar to what
  " you liked about Gdiff

  "}}}

  " note taking {{{
  " Plug 'danchoi/soywiki' " aims to be a lightweight vimwiki, with a more focused featureset
  "   NOTE: no longer actively maintained, since 2013-ish
  " Plug 'fcpg/vim-waikiki' " aims to be a lightweight vimwiki, with a more focused featureset
    " https://github.com/fcpg/vim-waikiki
  " Plug 'lervag/wiki.vim' " a more minimal take on vimwiki, 'do one thing well' philosophy
    " https://github.com/lervag/wiki.vim
  Plug 'vimwiki/vimwiki' , { 'on': 'VimwikiIndex' } " for personal wikis, todo's, etc
    Plug 'michal-h21/vim-zettel' " adds Zettelkasten note taking method into Vimwiki
      " https://github.com/michal-h21/vim-zettel

  " Plug 'alok/notational-fzf-vim' " an interesting marriage between FZF's fuzzyfinding powers and
  " the act of retreiving and/or creating new notes. Not sure how I feel about it yet, but it could
  " be something worth checking out.

  " NOTE: In practice, I found vim-pandoc-syntax to introduce a VERY PRONOUNCED sluggishness and
  " unresponsiveness to vim while editing the journal.md file. Adding a new lines and basic stuff
  " like that took FOREVER. So maybe I'm not entirely correct about what pandoc does? What it may be
  " trying to do? Either way, for now I went ahead and disabled them.
  " Plug 'vim-pandoc/vim-pandoc'
  " Plug 'vim-pandoc/vim-pandoc-syntax'
    " https://pandoc.org/MANUAL.html
    " NOTE: vim-pandoc and its sister syntax plugin provide vim with a variety of markdown syntax
    " options along with the means for saving the file into numerous formats. For example, did you
    " know that MS Word is essentially a markdown syntax interpreter of sorts? This means you can
    " use a word compatible syntax then save the file in a word friendly format and BOOM! There ya
    " have it, a word doc created entirely in vim. Pretty cool eh?
    "
    " Whereas HTML is markup specifically designed around web interfaces, you can think of markdown
    " itself as being much more generic, with a variety of different 'flavors' depending on what
    " you're seeking to accomplish.
    "
    " For example, the markdown you use on Reddit is based on this kind of 'universal' markdown
    " syntax and is usable directly within pandoc

  "}}}

  "pomodoro --------------------{{{
  " Plug 'mnick/vim-pomodoro'
  " Plug 'zuckonit/vim-airline-tomato'

  "}}}

  " react ----------------------{{{
  " Plug 'pangloss/vim-javascript' " officially supported companion to vim-jsx
    " NOTE: This is required for vim-jsx to run
  " Plug 'mxw/vim-jsx' " for React
  " Plug 'MaxMEllon/vim-jsx-pretty' " syntax highlighting

  "}}}

  "search boosters like ag and ripgrep -> enable only one -------{{{
  "UPDATE: Okay, actually I may have understood this wrong. Once you install something like ag or
  "ripgrep into your Linux OS, the next step is to get it recognized/usable by Vim. And on this
  "front, FZF provides that ability. So whenever you're rocking and rolling in Vim and you CTRL-s
  "(which pulls up :Ag! in vim's prompt), you're actually piggybacking off of some functionality
  "that FZF brings to the table and displaying the results within an fzf context. Which means you
  "likely do not need any of the plugins mentioned in this section
  "NOTE: In order for these to work you also need to install stuff to your linux. Note that if you
  "decide to use ripgrep, it has a different setup procedure that you've outlined in the reference
  "file under vim's initial installs
  "NOTE: Depending on which on you choose, you'll need to go down to Plugin Settings and enable the
  "custom keybindings, etc

  "   For ag:
  "
  "     $ sudo apt install silversearcher-ag
  "
  "   For ack:
  "
  "     www.beyondgrep.com/install/
  "
  "   NOTE: As of 20180425, ack-grep is still not yet hosted in the Ubuntu 17.10 package
  "   listing. From reading a bit on the forums, there seems to be some weird issue going on where
  "   Ubuntu is rejecting it from its packages due to some odd test failure. The dev is aware of the
  "   issue and appears to be working to resolve it, though it seems Ubuntu-related parties are
  "   being slow and/or non-responsive as to what is exactly causing the issue. Luckily, there are
  "   several other ways to install it.
  "
  "     https://www.askubuntu.com/questions/972083/unable-to-find-ack-in-ubuntu-17-10-repositories
  "     https://packages.ubuntu.com/search?suite=artful&keywords=ack
  "
  "       $ sudo apt-get install ack-grep # DOES NOT WORK PER ABOVE NOTE
  "
  "     Another way of installing is through Perl's own CPAN installer
  "
  "       $ sudo apt install cpanminus
  "       $ sudo cpanm install App::Ack
  "
  " Plug 'BurntSushi/ripgrep'
  "   NOTE: Requires the following installs
  "     $ sudo apt install ripgrep
  "     $ sudo apt install cargo
  "     $ curl https://sh.rustup.rs -sSf | sh
  "       If you run into issues, you may need to update your rust version
  "         $ rustup update stable
  "     cd into the ripgrep plugin directory so you can 'build' ripgrep
  "     $ cd ~/.vim/plugged/ripgrep
  "     $ cargo build --release
  "     $ ./target/release/rg --version
  "       If everything went through okay, you should see a version listing here
  "     From here, you then need to go into .bashrc and comment out some of the lines you've
  "     included in order to tell fzf to use the ripgrep engine
  "
  " Plug 'dyng/ctrlsf.vim' " Some people use this as an alternative to fzf, but in my brief
  "   experience with it, it seems to be a text searching tool WITHIIN files, similar to how you use
  "   ag vim with <C-s>
  " Plug 'epmatsw/ag.vim' " appears to be no longer maintained
  " Plug 'gabesoft/vim-ags' " appears to be no longer maintained
  " Plug 'jremmen/vim-ripgrep' " supposedly faster than ack/ag, though requires some additional
  "   setup to work with FZF
  " Plug 'mileszs/ack.vim' " Alternative to ag.vim, still maintained. Confirmed to work with default
  "   FZF settings
  " Plug 'mhinz/vim-grepper' " supposedly works with ag silversearcher. Think it provides similar
  "   functionality to rking/ag.vim which was your previous go-to
  " Plug 'rking/ag.vim' " appears to be no longer maintained, though this is the I previously used

  "}}}

  "search and replace related tools --------{{{
  " Plug dyng/ctrlsf.vim " async search tool for use with ack/ag/ripgrep, etc
  " Plug 'haya14busa/is.vim'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim' ", { 'on': '<Plug>Gfiles' }
    " NOTE: 20190823 FZF, by default, is set to use one of the 'ag' search variants. One of the issues
    " you ran into when getting things set up on Manjaro (arch linux) was that after install vim and
    " getting things up and running, <C-p> would always show 0/0 and never list any files. In this
    " instance, to get it working, all you had to do was intall one of the ag searchers, ala
    "
    "   $ sudo pacman -S the_silver_searcher
    "
    " NOTE: May be a good idea to use it in conjunction with something like fd-find. Now, fd-find
    " requires >= Ubuntu 19.04 if you're wanting to install through the package manager, but in the
    " event you're running something older, you can always install it through npm/pnpm
    "
    "   $ pnpm install -g fd-find
    "
    " or you can install it from the git source
    " or you can install with something like curl
    "
    " Here's how some of those break-down:
    "   1) $ sudo apt install fd-find
    "     UPDATE: Nope, not available in debian package manager (req >= 19.04) have to go the git
    "     route cd into whatever directly you want to download the file to, then run
    "         $ curl -O https://github.com/sharkdp/fd/releases/download/v7.2.0/fd_7.2.0_amd64.deb
    "         UPDATE: curl commands are a little weird for github since there's a different 'backend'
    "         website. So for now, just do it the oldschool way listed next...
    "       Download the latest release from the github page
    "         https://github.com/sharkdp/fd/releases
    "       Then cd into the containing directory and run the following command
    "         $ sudo dpkg -i fd_7.2.0_amd64.deb (or whatever version you downloaded)
    "   2) Go into the .bashrc file and update the fzf command to utilize fd-find (see further notes
    "      there)
    "   3) restart your terminals that are up and you should be good to go :)
  " Plug 'kien/ctrlp.vim'
  Plug 'markonm/traces.vim'
    " NOTE: This adds match highlighting when using vim's :substitute and related commands
  Plug 'nelstrom/vim-visual-star-search' " let's * work on visual selections
  " Plug 'romainl/vim-cool' " disables search highlighting after leaving search, adds counter
  "   NOTE: The counter functionality can be replicated with the use of vim's now built-in shortmess
  "   setting. It's automatic 'cancelling' of the search highlights can be achieved with :nohlsearch
  " Plug 'tpope/vim-abolish' " able to find and replace different variants of a word
  Plug 'wincent/scalpel'
    " NOTE: improves upon vim's default replace 'flow' when using :%s, comes with its own mappings
  " Plug 'Yggdroot/LeaderF', { 'do': '.\install.bat' }

  "}}}

  "sidebars, file explorers and others --------------{{{
  "buffers {{{
  Plug 'jlanzarotta/bufexplorer' , { 'on': 'BufExplorer' } " buffer viewer

  "}}}

  "files {{{
  " NOTE: One of the main reasons many people start to look for netrw alternatives is because the
  " plugin itself is supposedly REALLY large in size for what it does and has some longstanding issues
  " that have been repeatedly ignored by its developer/s. So that said, if you're interesting in
  " venturing out to netrw alternatives, here's how :)
  "
  " The following command disables the vim's 'default' netrw from loading (comment out the line if you
  " want it to load):

    " let loaded_netrwPlugin = 0

  " If you ever want to check if netrw is loaded while you're in vim, use
  "
  "   :echo g:loaded_netrwPlugin
  "
  " and if it returns something OTHER than the above value, you know it's been loaded.
  " That said, however, there's a *chance* you may run into issues if you don't have netrw loaded.
  " According to a post I saw in a google group:
  "
  "   I don't know about NERDtree; but if you disable netrw, Vim will give you an error instead when
  "   you try to open a directory: the main purpose of the netrw plugin is to allow Vim to display the
  "   contents of a directory when you 'edit' it.
  "
  " There are evidently some features in netrw that you may find useful at some point. But for your
  " current use cases, you may be fine running something that's more lean and mean. That's why dirvish
  " gets high marks, for example.

  " NOTE: These are plugins that either enhance or replace the built-in :netrw stuff
  " Plug 'francoiscabrol/ranger.vim'
  "   NOTE: ranger ris a stand-alone terminal based file manager, this plugin just integrates it
  "   within vim
  " Plug 'justinmk/vim-dirvish' " different take on netrw, meant to be a full replacement of netrw (ie
  "   disable netrw),
      " Plug 'kristijanhusak/vim-dirvish-git' " adds git status symbols to the dirvish listing
      " Plug 'roginfarrer/vim-dirvish-dovish', {'branch': 'main'} " adds numerous file manipulation
      " mappings, see config section for notes on use. May want to re-enable some of the stuff there
      " you've commented out
      " NOTE: I wanted to like dirvish, but I just found it to be a bit too minimal for my taste at
      " this time. There is some very basic stuff offered by the netrw+vinegar combo (moving and
      " renaming files, etc) that isn't as readily available through dirvish. Throw in tpope's eunuch
      " plugin, and the netrw-vin-eun combo is tough to beat if you're not concerned with their added
      " overhead
  " Plug 'lambdalisue/fila.vim'
  "   NOTE: From what I can tell, this has since been renamed to fern.vim
  " Plug 'lambdalisue/fern.vim'
    " NOTE: List of plugins here: https://github.com/lambdalisue/fern.vim/wiki/Plugins
  " Plug 'lambdalisue/fern-git-status.vim'
  " Plug 'lambdalisue/fern-mapping-mark-children.vim'
  " Plug 'lambdalisue/fern-renderer-nerdfont.vim'
    " NOTE: requires the following
    " Plug 'lambdalisue/nerdfont.vim'
  "
  " nnn
  Plug 'mcchrish/nnn.vim'
  " Plug 'voldikss/vim-floaterm#nnn'
  "
  " Plug 'Shougo/defx.nvim'
  " Plug 'tpope/vim-eunuch' " Adds things like :Mkdir, :Delete, and :Move, etc. Can be used in
    " netrw/vinegar buffers too!
  Plug 'tpope/vim-vinegar' " modifies a few things with netrw, adds auto-refresh.
  "   NOTE: Because this supplements netrw, you'll need to NOT activate the line that disables netrw
  "   from starting

  "}}}

  "macros {{{
  Plug 'svermeulen/vim-macrobatics' " displays history of macros, similar to mundo for undos

  "}}}

  "minimap {{{
  " Plug 'severin-lemaignan/vim-minimap' " adds minimap on right side
    " NOTE: Cool! But it adds a bit of lag and, aside from the glitter, I don't really feel it adds
    " that much

  "}}}

  "registers {{{
  " Plug 'junegunn/vim-peekaboo' " Displays the contents of active registers. Though this may be
  "   unneeded given you have :reg?
  "   NOTE: Trying to lazyload the plugin, but I can't seem to get the 'on' method right for it...
  "     Plug 'junegunn/vim-peekaboo' , { 'on': '<Plug>(peekaboo)' }
  "}}}

  "undo {{{
  " Plug 'mbbill/undotree' " alternative to gundo
  Plug 'simnalamburt/vim-mundo', { 'on': 'MundoToggle'} " active development fork of gundo
  " Plug 'sjl/gundo.vim' " undo tracking sidebar

  "}}}

  "}}}

  "snippets --------------------{{{
  " NOTE: There is overlap between these plugins, so your best bet is to use one at a time.
  " Plug 'garbas/vim-snipmate'
  " Plug 'justinj/vim-react-snippets'
  Plug 'mattn/emmet-vim'
  " Plug 'SirVer/ultisnips'
  "   NOTE: This is just the 'server', need to also include a snippets pack, like
  "   Plug 'honza/vim-snippets'

  "}}}

  " startup testing {{{
  " Plug 'dstein64/vim-startuptime'
  Plug 'tweekmonster/startuptime.vim'

  "}}}

  "statusline -------------------{{{
  "NOTE: for plugins, lightline is your reigning fav at this point in time :)

  " Plug 'powerline/powerline'

  " Plug 'vim-airline/vim-airline'
  " Plug 'powerline/fonts' " These can be used with lightline too
  " Plug 'vim-airline/vim-airline-themes'

  " Plug 'itchyny/lightline.vim'
  " Plug 'mgee/lightline-bufferline'
  "   NOTE: If plugin is disabled, must comment out lightline-bufferline settings
  Plug 'itchyny/vim-gitbranch'
  "   NOTE: This works as a standalone plugin as well, for use in standard statusline

  " Plug 'rbong/vim-crystalline'
  " NOTE: This is intended to be a kind of barebones, easy to configure statusline plugin. The catch
  " is though, is that it seems the user is expected to 'build his own', so to speak. I've loved
  " lightline so far and at this point, don't see any reason to change over, especially if it will
  " require additional configuration.

  Plug 'sunaku/vim-modusline' " changes the color of the statusline to reflect what mode vim is in

  "}}}

  "syntax and file types -------{{{
  Plug 'sheerun/vim-polyglot' " collection of language packs, loads on demand
    " NOTE: This should be a catch-all for all of the below

  " Plug 'cakebaker/scss-syntax.vim'
  " Plug 'elzr/vim-json'
  " Plug 'jelera/vim-javascript-syntax'
  " Plug 'lervag/vimtex' " latex support
    " :h vimtex
  " Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
  " Plug 'plasticboy/vim-markdown' " Is this needed? vim may support markdown syntax out of the box...
  Plug 'vim-ruby/vim-ruby' " evidently this can REALLY help with syntax lag when in a *.rb file
  " Plug 'othree/html5.vim'
  "
  " NOTE: In addition to these syntax highlighting files, using a linter to help format your code is
  " recommended
  "   $ npm install --save-dev eslint
  "   $ npm install --save-dev babel-eslint
  "   $ npm install --save-dev eslint-plugin-react
  "
  "   Create a config file .eslint.json in your project's root directory with:
  "   $ ./node_modules/.bin/eslint --init
  "
  "   Then, you must integrate ESLint with Vim's Syntastic plugin by adding the following to your
  "   .vimrc

  "   let g:syntastic_javascript_checkers = ['eslint']

  " Coffeescript ---------------
  " Plug 'kchmck/vim-coffee-script' " adds syntax, indenting, live preview compiling, and more
    " NOTE: in order to use the run and preview stuff, you need coffeescript installed `$ sudo npm
    " install coffeescript`

  "}}}

  "taskwarrior -----------------{{{
  "UPDATE: In addition to the below note, I also found that enabling vim-taskwarrior causes a number
  "of conflicts with other plugin settings. So I'm going to leave it out for now...
  "NOTE: After trying out vim-taskwarrior for a bit, I realize that I prefere the default CLI
  "interface offered by TW. Now, it's possible that the taskwiki plugin could come in handy if/when
  "I decide to try and link it up to vimwiki since I use that for my journal stuff. But for right now,
  "I'll keep them separate.
  " Plug 'blindFS/vim-taskwarrior' " provides a vim interface for taskwarrior commands
  " Plug 'tbabej/taskwiki' "taskwarrior integration into vimwiki plugin, syncs vimwiki to taskwarrior
  "   related files
  "   https://github.com/tbabej/taskwiki
  " NOTE: also requires `$ sudo pip install --upgrade git+git://github.com/tbabej/tasklib@develop`
  " Related Plugin recommendations:
    " Plug 'powerman/vim-plugin-AnsiEsc' " adds color support for charts
    " Plug 'blindFS/vim-taskwarrior' " enables grid view
    " Plug 'majutsushi/tagbar' " provides taskwiki file navigation

  "}}}

  "text alignment --------------{{{
  Plug 'godlygeek/tabular' " easily align text along given regexp
  " Plug 'junegunn/vim-easy-align' " alternative to tabular

  "}}}

  "text-objects {{{
  " Plug 'hgiesel/vim-motion-sickness'
  "   NOTE: Alternative to targets.vim
  " Plug 'kana/vim-textobj-user'
  "   NOTE: Create your own text objects
  " Plug 'michaeljsmith/vim-indent-object'
  "   NOTE: Adds an indentation related object so you can call up indentation stuff with motion
  "   operators
  " Plug 'whatyouhide/vim-textobj-erb' "
  "   NOTE: requires kana/vim-textobj-user
  "   NOTE: The mnemonic is to think 'erb' = E
  "   viE = visually select inside erb block
  "   ciE = change inside erb block
  "   daE = delete around erb block
  "   ... etc etc
  Plug 'wellle/targets.vim'

  "}}}

  "tmux ------------------------{{{
  " Plug 'benmills/vimux' " allows tmux commands to be issued from inside vim

  " Plug 'christoomey/vim-tmux-navigator' " blends vim pane switching with tmux's window switching
    " NOTE: Must disable any .vimrc keybindings related to pane switching
    " NOTE: Also requires further activation of companion plugin for tmux, found in your .tmux.conf
  " Plug 'edkolev/tmuxline.vim' " this is a tmuxline generator that tries to match itself to whatever
  "   you're using in vim. Cool, I guess, but not something I feel like I want or need right now.
  " Plug 'roxma/vim-tmux-clipboard' " anything copied in tmux is automatically also copied to vim's
  "   <double quote> register
    " NOTE: Always had this one enabled, but I'm trying to slim down my config, curious if I really
    " use it that much and/or if it's still required. I've read some users say that copy/pasting works
    " just fine without it now
  " Plug 'tmux-plugins/vim-tmux-focus-events' " enables tmux's focus-gained and focus-lost events in
  "  terminal vim
  "   UPDATE: No longer needed since 8.2+

  "}}}

  "uml diagrams and others ----------------{{{
  " NOTE: These require PlantUML +dependancies to be installed to the system via PackageManager
  " Plug 'aklt/plantuml-syntax' " vim syntax file for PlantUML
  " Plug 'burntsushi/erd/' " visual diagram modeling
  " Plug 'willchao612/vim-diagon'
  "   NOTE: Requires Diagon
  "     https://github.com/ArthurSonzogni/Diagon
  "       Compile from git source or
  "       $ sudo snap install diagon

  "}}}

  "window tools ----------------{{{
  " NOTE: While these plugins can  make things a bit easier, something similar can be achieved either
  " through the goyo plugin, OR by using vim's built in commands to stretch and expand windows
  " Plug 'camspiers/lens.vim'
  " Plug 'regedarek/zoomwin' " v.25
  Plug 'wesQ3/vim-windowswap' " allows you to swap the contents of one window with another window
  "   NOTE: Temporarily disabling, may be conflicting with vimwiki's keybinds...
  " NOTE: I've tried the below multiple times and they're just not for me. I prefer to be able to SEE
  " the contents of the open windows rather than have them tucked away to make room for the blown up
  " active window
  " Plug 'roman/golden-ratio' " con: does not resize non-active windows
  " Plug 'zhaocai/goldenview.vim' pro: resizes non-active windows

  "}}}

  " word motions {{{
  " Plug 'chaoren/vim-wordmotion' " takes camelCase and snake_case divisions into account for word
  " motions
  "   NOTE: Nice on paper, but in practice, I found it cumbersome. Maybe setting up a proper prefix
  "   could help?
  " Plug 'easymotion/vim-easymotion' " jump to specific place on screen, similar to jumpy in Atom
  Plug 'justinmk/vim-sneak' " a different take on easymotion, a LOT smaller
  " Plug 'unblevable/quick-scope' " highlights t and f motion positions. Why use this over easy-motion
  "   for word positions?

  "}}}

  call plug#end()

" }}}

  "plugin settings {{{
  "ack.vim "{{{
  " nmap     <C-s> :Ack<SPACE>
  " nnoremap <C-s> :Ack<SPACE>

  "}}}

  "ag.vim "{{{

  "}}}

  "airline "{{{
  " let g:airline_theme='wombat'
  " let g:airline#extensions#tabline#enabled = 1
  let g:airline_powerline_fonts = 1

  "}}}

  "ale "{{{
  let g:ale_lint_on_text_changed = 'never' " default 'always'
  let g:ale_lint_delay = 1000 " default 200

  " NOTE: This setting allows you setup different linter 'engines' for certain file types.
  " let g:ale_linters = { 'javascript': ['eslint'],
  "                       'css': ['stylelint'],
  "                       'scss': ['stylelint'] }

  " let g:ale_use_global_executables = 1

  " NOTE: Fixing is different from linting, additional configuration and files may be needed to 'fix'
  "   a file
  " let g:ale_fix_on_save = 1
  " let g:ale_fixers = { 'javascript': ['eslint'] }
  " let g:ale_fixers = { 'javascript': ['prettier', 'eslint'] }
  " let g:ale_fixers = { 'javascript': ['jshint'] }
  " let g:ale_fixers = { 'javascript': ['prettier', 'jshint'] }

  "}}}

  " any-jump {{{
  nnoremap <leader>j :AnyJump<CR>
  let g:any_jump_search_prefered_engine = 'ag'

  let g:any_jump_window_width_ratio = 0.8
  let g:any_jump_window_height_ratio = 0.8
  let g:any_jump_window_top_offset = 2

  let g:any_jump_ignored_files = ['vendor', 'config', 'bin', 'node_modules', 'public/assets']

  let g:any_jump_grouping_enabled = 1
  let g:any_jump_list_numbers = 1

  "}}}

  " asyncomplete.vim {{{
  let g:asyncomplete_auto_popup = 1

  "}}}

  "auto-pairs {{{
  let g:AutoPairsMapSpace = 0 " default 1
  " NOTE: Hopefully this will help with the additional spacing that occurs whenever you try to make
  " a new vimwiki [ ] thing

  "}}}

  "bufexplorer {{{
  "<leader>be # open in current window
  "<leader>bt # toggle in current window
  "<leader>bs # open in horizontal split
  "<leader>bv # open in vertical split

  "<F1> # toggle help
  "<CR> # open cursored buffer into current window
  "t # open cursored buffer in new tab
  "f # open below
  "F # open above
  "v # open right
  "V # open left
  "T # toggle show buffers only in this tab
  "u # toggle show unlisted buffers
  "q # close bufexplorer
  "s # cycles through various orderings

  let g:bufExplorerShowRelativePath=1 " default 0 - show absolute paths
  let g:bufExplorerDefaultHelp=0 " default 1 - show help at the very top

  "}}}

  "calendar.vim {{{
  " :Calendar # to launch
  " q # to quit
  " < > # switch between views
  let g:calendar_frame = 'default' " helps standardize column formatting
  let g:calendar_task = 1

  " Uncomment below to integrate with google. Will need to setup with curl too
  "let g:calendar_google_calendar = 1
  " let g:calendar_google_task = 1

  "}}}

  "CtrlP {{{
  " let g:ctrlp_match_window = 'bottom,order:ttb' " order matching files top to bottom
  " let g:ctrlp_switch_buffer = 0 " always open files in new buffers
  " let g:ctrlp_working_path_mode = 0 " ctrlp respects working directory changes in vim session
  "
  " " Makes ctrlp wicked fast if you have ag installed
  " if executable('ag')
  "   set grepprg=ag\ --nogroup\ --nocolor
  "   let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
  " " Below taken from thoughtbot dotfiles
  "   let g:ctrlp_user_command = 'ag -Q -1 --nocolor --hidden -g "" %s'
  "   let g:ctrlp_user_caching = 0 " ag is fast enough that ctrlp doesn't need to cache
  "   if !exists(":Ag")
  "     command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  "     nnoremap \ :Ag<SPACE>
  "   endif
  " endif
  "
  " " Default search by filename rather that full directory path
  " let g:ctrlp_by_filename = 1
  "
  " "}}}

  "CtrlSF {{{
  " nnoremap <C-s> :CtrlSF<SPACE>

  "}}}

  "comfortable-motion {{{
  " Defaults
  " g:comfortable_motion_interval = 1000.0/60
  " g:comfortable_motion_friction = 80.0
  " g:comfortable_motion_air_drag = 2.0

  " Friction Only
  " let g:comfortable_motion_friction = 200.0
  " let g:comfortable_motion_air_drag = 0.0

  " Air Resistance Only
  " let g:comfortable_motion_friction = 0.0
  " let g:comfortable_motion_air_drag = 4.0

  " Scroll relative to window's height
  let g:comfortable_motion_no_default_key_mappings = 1
  let g:comfortable_motion_impulse_multiplier = 4 " default 1
  " nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
  " nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
  " nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
  " nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>"}}}

  " completor.vim {{{
  " NOTE: This intends to have a 'smart' Tab implementation that first checks to see if you're in the
  " middle of typing a word before it interprets your Tab press as a completor trigger. Otherwise, it
  " will function as a normal <Tab> press. Very cool!
  " function! Completor_Tab_or_Complete() abort
  "   if pumvisible()
  "     return "\<C-n>"
  "   elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
  "     return "\<C-r>=completor#do('complete')\<CR>"
  "   else
  "     return "\<Tab>"
  "   endif
  " endfunction

  " Tab and Shift-Tab cycle through results
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  let g:completor_auto_trigger = 0 " default 1
  " inoremap <expr> <Tab> Completor_Tab_or_Complete()
  "   NOTE: Enable above keybind and comment out the 'standard' Tab_or_Complete() function

  "}}}

  "ddc.vim {{{
    " Customize global settings
    " Use around source.
    " https://github.com/Shougo/ddc-around
    call ddc#custom#patch_global('sources', ['around'])

    " Use matcher_head and sorter_rank.
    " https://github.com/Shougo/ddc-matcher_head
    " https://github.com/Shougo/ddc-sorter_rank
    call ddc#custom#patch_global('sourceOptions', {
          \ '_': {
          \   'matchers': ['matcher_head'],
          \   'sorters': ['sorter_rank']},
          \ })

    " Change source options
    call ddc#custom#patch_global('sourceOptions', {
          \ 'around': {'mark': 'A'},
          \ })
    call ddc#custom#patch_global('sourceParams', {
          \ 'around': {'maxSize': 500},
          \ })

    " Customize settings on a filetype
    call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
    call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
          \ 'clangd': {'mark': 'C'},
          \ })
    call ddc#custom#patch_filetype('markdown', 'sourceParams', {
          \ 'around': {'maxSize': 100},
          \ })

    call ddc#custom#patch_global('completionMode', 'manual')

    " Mappings

    " <TAB>: completion.
    inoremap <silent><expr> <TAB>
    \ pumvisible() ? '<C-n>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#manual_complete()

    " <S-TAB>: completion back.
    inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

    " Use ddc.
    call ddc#enable()

  " }}}

  "deoplete {{{
  " :help deoplete-options

  " let g:deoplete#enable_at_startup = 1

  " NOTE: This intends to have a 'smart' Tab implementation that first checks to see if you're in the
  " middle of typing a word before it interprets your Tab press as a trigger. Otherwise, it will
  " function as a normal <Tab> press. Very cool!
  " function! Deoplete_Tab_or_Complete() abort
  "   if pumvisible()
  "     return "\<C-n>"
  "   elseif col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
  "     return "\<C-r>=deoplete#manual_complete()\<CR>"
  "   else
  "     return "\<Tab>"
  " endfunction

  " Tab and Shift-Tab cycle through results
  " inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  " inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " call deoplete#custom#option('auto_complete', v:false)
  "   NOTE: Enable above call to manually invoke it to display
  " inoremap <expr> <Tab> Deoplete_Tab_or_Complete()
  "   NOTE: Enable above keybind and comment out the 'standard' Tab_or_Complete() function

  "}}}

  "diffconflicts {{{
  " :DiffConflictsShowHistory " open additional tabs that include traditional three-way vimdiff. This
  " command *might* come already pre-set to the following shortcut:
  "   <leader>D
  "
  " On use: The left hand side is the one that you'll end up 'keeping'. In his example video, he
  " generally goes through the edits by hand, copy and pasting things over from the right side into
  " the left side if they're that straightforward or making a mix and match of both worlds if there
  " are elements he wants from both instances. The three-way view, he says, can be useful when you're
  " trying to suss out the history or thinking behind some of the changes that are noted, but aside
  " from that, he strongly recommends doing all edits and changes in the two-way view.
  " https://www.youtube.com/watch?v=Pxgl3Wtf78Y

  "}}}

  "emmet-vim {{{
  "<C-y>, " execute emmet on typed line, while in insert mode
    " NOTE: Notice the , key being pressed after <C-y>

  "Available commands: https://docs.emmet.io/
  " > # nested
    "div>ul>li # nested
      " <div>
      "   <ul>
      "     <li></li>
      "   </ul>
      " </div>
  " + # not nested, successive
    "div+p+bq  # one after another, not nested
      " <div></div>
      " <p></p>
      " <blockquote></blockquote>
  " ^ # move one level up, can be repeated as many times as you like
    " div+div>p>span+em^bq
      " <div></div>
      " <div>
      "   <p>
      "     <span></span>
      "     <em></em>
      "   </p>
      " </div>bq
  " * # multiply
    " ul>li*5
      " <ul>
      "   <l></l>
      " </ul>i*5
  " () # grouping
    " div>(header>ul>li*2>a)+footer>p
      " <div>
      "   <header>
      "     <ul>
      "       <li><a href=""></a></li>
      "       <li><a href=""></a></li>
      "     </ul>
      "   </header>
      "   <footer>
      "     <p></p>
      "   </footer>
      " </div>
  " # . # header and class designations
    " div#header+div.page+div#footer.class1.class2.class3
      " <div id="header"></div>
      " <div class="page"></div>
      " <div id="footer" class="class1 class2 class3"></div>
  " [] # attributes
    " td[title="Hello world!" colspan=3]
      " <td title="Hello world!" colspan="3"></td>
  " {} # href output
    " NOTE: Makes me wonder... Could I customize this to ouput a Rails link_to helper instead?
    " a{click me}
      " <a href="">click me</a>
  " lorem<number> # inserts lorem text to the stated length
    " lorem50
    " <div>
    "   Elit pariatur accusamus consequuntur impedit provident. Quam mollitia quam pariatur dolorum
    "   blanditiis Pariatur vel possimus rem exercitationem assumenda. Odit fuga exercitationem
    "   aperiam adipisci ratione. Magnam eaque dolores distinctio molestias provident molestias, modi
    "   praesentium Excepturi sint cum voluptatibus laborum modi iusto. Exercitationem cupiditate
    "   alias molestias laborum error? Quae at sapiente expedita!
    " </div>

  "}}}

  "fern.vim" {{{
    " ? or 'action: help'
    " a # 'action', follow with what action you'd like to perform

    noremap <silent><leader>f :Fern %:h -drawer<CR>

  " }}}

  "FZF {{{
  " NOTE: Any fzf related command that is ended with an exclamation point will open it in fullscreen
  " mode In practice, I've found this causes less conflict with colorschemes not displaying properly

  " nnoremap <C-p> :FZF<CR>
  " nnoremap <C-p> :GFiles<CR>
  nnoremap <C-p> :GFiles!<CR>
    " NOTE: Changed default command to :GFiles so it would respect the .gitignore setup and not pull
    " in results from places like node_modules, etc
  " nnoremap <C-b> :Buff<CR>
  nnoremap <C-b> :Buff!<CR>
  " nnoremap <C-m> :Marks<CR>
  nnoremap <C-m> :Marks!<CR>
  nnoremap <C-e> :FZF!<CR>

  nmap     <C-s> :Ag!<SPACE>
  nnoremap <C-s> :Ag!<SPACE>
  " nmap     <C-s> :Rg<SPACE>
  " nnoremap <C-s> :Rg<SPACE>

  " https://github.com/junegunn/fzf
  " <1> <2>        # fuzzy match that contains both <1> and <2>, add space between the search terms
  " '<wild>        # wildcard
  " ^<prefix>      # items that start with <prefix>
  " .<suffix>      # items that end with <suffix>
  " !<not>         # items that do NOT include <not>
  " !^<not-prefix> # items that do not start with <not-prefix>
  " !.<not-suffix> # items that do not end with <not-suffix>

  " https://github.com/junegunn/fzf.vim#commands
  "   :Buff<CR> # search through buffer list
  "   :BTags # search for tags within buffer
  "   :Tags  # search for tags across entire project
  "   :Marks
  "   :Helptags # view a fzf-like searchable for vim's :help documentation. Wow!
  "   :Maps

  " classic style
  " let g:fzf_layout = { 'up': '~50%' }

  " popup style
  " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9, 'highlight': 'Todo', 'rounded': v:true } }
  let g:fzf_preview_window = '' " disables preview window altogether

  " let g:fzf_buffers_jump = 1 " This goes to the matching buffer, if open

  "}}}

  " golden-ratio {{{
  " " disable gr from automatically firing
  let g:golden_ratio_autocommand = 0
  " " resize current window to ratio
  " nmap <C-w>- <Plug>(golden_ratio_resize)
  " " fill screen with current window
  " nnoremap <C-w>= <C-w><Bar><C-w>_
  "}}}

  "goldenview {{{
  " let g:goldenview__enable_default_mapping=0
  " nmap <leader><gv> :ToggleGoldenViewAutoResize
  "
  "}}}

  "goyo {{{
  nmap <silent><leader>g :Goyo<CR>
  " let g:goyo_width=130
  let g:goyo_width=110
  " let g:goyo_width=200

  " NOTE: Not sure how to get to show the line numbers. set number will show them
  " function! s:goyo_enter()
  "   set number
  " endfunction

  "}}}

  "Gundo {{{
  " nnoremap <F5> :GundoToggle<CR>
  " let g:gundo_prefer_python3 = 1

  "}}}

  "gruvbit {{{
  " let g:gruvbit_transp_bg = v:true

  "}}}

  "lexima {{{
  let g:lexima_enable_basic_rules = 1 " default 1
  let g:lexima_enable_newline_rules = 1 " default 1
  let g:lexima_enable_endwise_rules = 0 " default 1

  " NOTE: lexima conflicts with many code completion popup windows, causing <CR> to always insert
  " a new line rather than only 'select' from the list. Supposedly, the below is a fix for this,
  " though I couldn't get it to work...
  " https://github.com/cohama/lexima.vim/issues/65#issuecomment-339338677
  " let g:lexima_no_default_rules = 1
  " call lexima#set_default_rules()
  " call lexima#insmode#map_hook('before', '<CR>', '')

  " function! My_cr_function() abort
  "   " return deoplete#close_popup() . lexima#expand('<CR>', 'i')
  "   return deoplete#close_popup()
  " endfunction

  " inoremap <expr> <cr> <sid>my_cr_function()

  " inoremap <expr> <CR> pumvisible() ? My_cr_function() : "\<C-g>u\<CR>"

  "}}}

  "lightline {{{
  " NOTE: Recommend enabling noshowmode, see statusline settings

  " Configs {{{
  "Default setup"{{{
  " let g:lightline = {}
  "}}}

  " With only lineinfo and percent on the right side of active window "{{{
  " let g:lightline = {
  "       \ 'active': {
  "       \   'left': [ [ 'mode', 'paste' ],
  "       \             [ 'readonly', 'filename', 'modified' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ], [ 'filetype' ] ]
  "       \ },
  "       \ 'inactive': {
  "       \   'left': [ [ 'filename', 'modified' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ] ]
  "       \ }
  "       \ }

  "}}}

  " With vim-gitbranch "{{{
  let g:lightline = {
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ], [ 'filetype' ] ]
        \ },
        \ 'inactive': {
        \   'left': [ [ 'filename', 'modified' ] ],
        \   'right': [ [ 'lineinfo' ],
        \              [ 'percent' ] ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'gitbranch#name'
        \ },
        \ }

  "}}}

  " with syntastic {{{
  " let g:lightline = {
  "       \ 'active': {
  "       \   'left': [ [ 'mode', 'paste' ],
  "       \             [ 'readonly', 'filename', 'modified' ],
  "       \             [ 'syntastic' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ], [ 'filetype' ] ]
  "       \ },
  "       \ 'inactive': {
  "       \   'left': [ [ 'filename', 'modified' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ] ]
  "       \ },
  "       \ 'component_expand': {
  "       \   'syntastic': 'error',
  "       \ },
  "       \ }

  "}}}

  " With gutentags status {{{
  " let g:lightline = {
  "       \ 'active': {
  "       \   'left': [ [ 'mode', 'paste' ],
  "       \             [ 'readonly', 'filename', 'modified' ],
  "       \             [ 'gutentags' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ], [ 'filetype' ] ]
  "       \ },
  "       \ 'inactive': {
  "       \   'left': [ [ 'filename', 'modified' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ] ]
  "       \ },
  "       \ 'component_function': {
  "       \   'gutentags': 'gutentags#statusline',
  "       \ },
  "       \ }

  "}}}

  " With ale linter components "{{{
  " let g:lightline =
  "       \ 'active': {
  "       \   'left': [ [ 'mode', 'paste' ],
  "       \             [ 'readonly', 'filename', 'modified' ] ],
  "       \   'right': [ [ 'linter_errors', 'linter_warnings', 'linter_ok' ],
  "       \              [ 'lineinfo' ],
  "       \              [ 'percent' ] ]
  "       \ },
  "       \ 'component_expand': {
  "       \   'linter_warnings': 'lightline#ale#warnings',
  "       \   'linter_errors': 'lightline#ale#errors',
  "       \   'linter_ok': 'lightline#ale#ok',
  "       \ },
  "       \ 'component_type': {
  "       \   'linter_warnings': 'warning',
  "       \   'linter_errors': 'error',
  "       \ },
  "       \ }
  " "}}}

  "With powerline font separators integrated "{{{
  "QUESTION: Any way to make the symbols smaller?
  " let g:lightline = {
  "   \ 'component': {
  "   \   'lineinfo': ' %3l:%-2v',
  "   \ },
  "   \ 'component_function': {
  "   \   'readonly': 'LightlineReadonly',
  "   \   'fugitive': 'LightlineFugitive'
  "   \ },
  "   \ 'separator': { 'left': '', 'right': '' },
  "   \ 'subseparator': { 'left': '', 'right': '' }
  "   \ }
  " function! LightlineReadonly()
  "   return &readonly ? '' : ''
  " endfunction
  " function! LightlineFugitive()
  "   if exists('*fugitive#head')
  "     let branch = fugitive#head()
  "     return branch !=# '' ? ''.branch : ''
  "   endif
  "   return ''
  " endfunction

  " "}}}

  "Custom setup "{{{
  " let g:lightline = {
  "       \ 'active': {
  "       \   'left': [ [ 'mode', 'paste' ],
  "       \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
  "       \   'right': [ [ 'lineinfo' ],
  "       \              [ 'percent' ],
  "       \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
  "       \ },
  "       \ 'component_function': {
  "       \    'gitbranch': 'fugitive#head',
  "       \    'relativepath' : '%f',
  "       \    'filename': 'LightlineFilename',
  "       \    'fileformat': 'LightlineFileformat',
  "       \    'filetype': 'LightlineFiletype',
  "       \ },
  "       \ 'separator': { 'left': '', 'right': '' },
  "       \ 'subseparator': { 'left': '', 'right': '' }
  "       \ }

  "       "}}}

  "}}}

  " Colorthemes {{{
  " NOTE: I really like the default theme because it colors the entire bar while in insert mode,
  " really makes it pop To see the full list of colorschemes available, type :h
  " g:lightline.colorscheme

  " let g:lightline.colorscheme = 'archery'
  " let g:lightline.colorscheme = 'challenger_deep'
  " let g:lightline.colorscheme = 'deus'
  " let g:lightline.colorscheme = 'gruvbox'
  "   NOTE: requires activation of separate plugin
  " let g:lightline.colorscheme = 'gruvbox_material'
  "   NOTE: requires activation of separate plugin
  " let g:lightline.colorscheme = 'hybrid'
  " let g:lightline.colorscheme = 'iceberg'
  "   NOTE: requires activation of separate plugin
  " let g:lightline.colorscheme = 'jellybeans'
  " let g:lightline.colorscheme = 'materia'
  " let g:lightline.colorscheme = 'material'
  " let g:lightline.colorscheme = 'nord'
  " let g:lightline.colorscheme = 'one'
  " let g:lightline.colorscheme = 'onedark'
  " let g:lightline.colorscheme = 'palenight'
  " let g:lightline.colorscheme = 'powerline'
  " let g:lightline.colorscheme = 'powerlineish'
  " let g:lightline.colorscheme = 'sacredforest'
  " let g:lightline.colorscheme = 'simpleblack'
  " let g:lightline.colorscheme = 'solarized'
  " let g:lightline.colorscheme = 'tender'
  " let g:lightline.colorscheme = 'Tomorrow'
  " let g:lightline.colorscheme = 'Tomorrow_Night'
  " let g:lightline.colorscheme = 'Tomorrow_Night_Blue'
  " let g:lightline.colorscheme = 'Tomorrow_Night_Eighties'
  " let g:lightline.colorscheme = 'wombat'

  "}}}

  " Misc {{{
  " Trim displayed info on narrow windows (doesn't seem to work...)
  " function! LightlineFileformat()
  "   return winwidth(0) > 70 ? &fileformat : ''
  " endfunction
  "
  " function! LightlneFiletype()
  "   return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
  " endfunction
  "}}}

  " Display plugin info at the filename component"{{{
  " function! LightlineFilename()"
  "   return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
  "       \ &filetype ==# 'unite' ? unite#get_status_string() :
  "       \ $filetype ==# 'vimshell' ? vimshell#get_status_string() :
  "       \ expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  " endfunction
  "
  " let g:unite_force_overwrite_statusline = 0
  " let g:vimfiler_force_overwrite_statusline = 0
  " let g:vimshell_force_overwrite_statusline = 0
  "}}}

  "}}}

  "lightline-bufferline {{{
  " let g:lightline#bufferline#show_number = 1
  " let g:lightline#bufferline#shorten_path = 1

  " let g:lightline.tabline          = {'left': [['buffers']], 'right': [['close']]}
  " let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
  " let g:lightline.component_type   = {'buffers': 'tabsel'}

  " "}}}

  "limelight {{{
  nmap <silent><leader>ll :Limelight!!0.9<CR>

  "}}}

  "lineletters {{{
  " nmap <silent>, <Plug>LineLetters

  "}}}

  "neocomplete {{{
  " <C-e> closes the popup window
  let g:neocomplete#enable_at_startup = 1
  let g:neocomplete#enable_auto_select = 1
  let g:neocomplete#auto_completion_start_length = 3 " default = 2

  "}}}

  "NERDTree {{{
  " map <silent><C-n> :NERDTreeFocus<CR>

  "}}}

  "netrw {{{
  "  NOTE: See vim-vinegar notes below if you're running that plugin as it makes some modifications to
  "   netrw.

  " :Explore  || :Ex  # enter file browsing mode in current tab/window
    " nmap <silent><leader>. :Explore<CR>
  " :Texplore || :Tex # new tab
  " :Sexplore || :Sex # horizontal split
  " :Vexplore || :Vex # vertical split
  " :Hexplore || :Hex # horizontal split
  " :Lexplore || :Lex # left explorer toggle
  " :Rexplore || :Rex # return to/from Explorer view

  " d  # create new directory
  " %  # make new file
  " R  # rename file
  " D  # delete file
  " gh # toggle hidden files
  " s  # change sort pattern
  " I  # toggle banner
  " i  # switch view style

  " From there, if you want to open one of the files cursored, just type
  "   <cr> # open cursored file in netrw area
  "   o    # open cursored file in same window
  "   h    # open cursored file in horizontal split
  "   v    # open cursored file in vertical split
  "   t    # open cursored file in new tab
  "   p    # open cursored file in preview window

  " If you ever want to refresh the directory listing
  "   <cr> on ./ directory entry up at the top

  " See :h Explore for more info, it's a pretty darn powerful little tool :)
  " Also :h netrw-browse-maps will show all the shortcuts commands and boy is there a LOT of them!

  " This is also where the vim-eunuch plugin comes into play! Simply type:
  "   :Mkdir <directory/name/here> and viola!
  "   :Mkdir! <directory/name/here> # akin to passing the "$ mkdir -p" command
  "
  " Moving Files
  "   mf # mark file/s for moving
  "   mt # select target directory for moving
  "   mm # move marked files to target directory
  "
  let g:netrw_altfile = 1 " <C-^> 0 returns to netrw browsing buffer, 1 returns to last edited file
  let g:netrw_banner = 0 " banner default on/off
  let g:netrw_browse_split = 0 " Sets default open file open style when selecting with <CR>
    " 0:same window, 1: h split, 2: v split, 3: new tab, 4: preview window
  let g:netrw_hide = 0 " hide dotfiles
  let g:netrw_liststyle = 1
    " 0:thin - one file per line
    " 1:long - with details
    " 2:wide - multiple columns
    " 3:tree
  let g:netrw_sizestyle = "H" " human-readable file sizes
  let g:netrw_winsize = 33 " percent of current buffer the netrw window should occupy, default 50

  " NOTE: Adds line numbers to netrw output
  " autocmd CursorHold * if (&filetype == 'netrw' && &number == 0) | set number | endif

  " NOTE: :Tex is also used by the vim-textobj-erb Plugin, trying to make it so it's just set to netrw
  " noremap <silent>:Tex :Texplore<CR>

  " NOTE: the vim-vinegar plugin adds the handy shortcut -
  " nmap <C-e> :Lex<CR>
  " nmap <C-e> :Explore<CR>

  " NOTE: Including this here more for reference more than anything else since I currently prefer to
  "   use :Lex
  " Toggle :Vex with <C-e>{{{
  " function! ToggleVExplore()
  "   if exists("t:expl_buf_num")
  "     let expl_win_num = bufwinnr(t:expl_buf_num)
  "     if expl_win_num != -1
  "       let cur_win_nr = winnr()
  "       exec expl_win_num . 'wincmd w'
  "       close
  "       exec cur_win_nr . 'wincmd w'
  "       unlet t:expl_buf_num
  "     else
  "       unlet t:expl_buf_num
  "     endif
  "   else
  "     exec '1wincmd w'
  "     Vexplore
  "     let t:expl_buf_num = bufnr("%")
  "   endif
  " endfunction
  " map <silent> <C-e> :call ToggleVExplore()<CR>

  "}}}

  "}}}

  "open-browser {{{
  nmap <silent><leader>b <Plug>(openbrowser-open)

  "}}}

  "open-in-browser {{{
  nmap <silent><leader><leader><leader>b :OpenInBrowser<CR>
  " NOTE: Taken from the readme, not sure if the html.erb stuff I added here will work or not
  let g:open_in_browser_allowed_file_types = {
      \"html": 1,
      \"htm": 1,
      \"xml": 1,
      \"html.erb": 1,
      \"erb": 1,
      \"eruby":1
    \}

  "}}}

  "quick-scope {{{
  nmap <leader>q <plug>(QuickScopeToggle)
  let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

  "}}}

  "startuptime.vim {{{
  "  :StartupTime to launch
  "}}}

  "syntastic {{{
  " set statusline+=%#warningmsg#
  " set statusline+=%{SyntasticStatuslineFlag()}
  " set statusline+=%*

  let g:syntastic_always_populate_loc_list = 1
  let g:syntastic_auto_loc_list = 0 " set to 1 to have it auto open when errors detected
  let g:syntastic_check_on_open = 1
  let g:syntastic_check_on_wq = 0
  let g:syntastic_loc_list_height = 2 " default is 10
  " NOTE: Disabling the shortcuts, I think it only supports <leader> and a single letter, and
  "   <leader>s poses a conflict
  " nmap <leader>synx :lclose<CR>
  " nmap <leader>syno :lopen<CR>

  " Checker setup
  " :SyntasticInfo # run this command with any open file to get some info for what synstastic has
  "   going on under the hood
  " :h syntastic-checkers
  " NOTE: it seems that some of these need to have the related npm packages installed on your system
  " in order to work. For example, if you want to use ESLint, which is very popular, you also need to
  " have ESLint setup and configured properly on your system before you can use it as
  " a syntastic-checker.
  let g:syntastic_javascript_checkers=['eslint'] " default is jshint

  " Lightline settings, enable when using the syntastic-enabled lightline layout
  " augroup AutoSyntastic
  "   autocmd!
  "   autocmd! BufWritePost *.c,*.cpp call s:syntastic()
  " augroup END

  " function! s:syntastic()
  "   SyntasticCheck
  "   call lightline#update()
  " endfunction

  "}}}

  "tabular {{{
  " <make visual selection>
  " :Tab/<xyz><CR>

  " So if you want to line things up by their colon, it'd look something like this
  "  :Tab/:

  " NOTE: Can't get this to work for some reason...
  " vmap <leader>t :Tab/

  "}}}

  "tagbar {{{
  nmap <F8> :TagBarToggle<CR>

  "}}}

  " targets.vim"{{{
  " Pair Mappings
  " a(  a)  a{  a}  aB  a[  a]  ar  a<  a>  aa at
  " I(  I)  I{  I}  IB  I[  I]  Ir  I<  I>  Ia It
  " A(  A)  A{  A}  AB  A[  A]  Ar  A<  A>  Aa At

  " in( in) in{ in} inB in[ in] inr in< in> ina int
  " an( an) an{ an} anB an[ an] anr an< an> ana ant
  " In( In) In{ In} InB In[ In] Inr In< In> Ina Int
  " An( An) An{ An} AnB An[ An] Anr An< An> Ana Ant

  " il( il) il{ il} ilB il[ il] ilr il< il> ila ilt
  " al( al) al{ al} alB al[ al] alr al< al> ala alt
  " Il( Il) Il{ Il} IlB Il[ Il] Ilr Il< Il> Ila Ilt
  " Al( Al) Al{ Al} AlB Al[ Al] Alr Al< Al> Ala Alt]

  " a ( bbbbbbbb ) ( ccccccc ) ( dddddd ) ( eeeeeee ) ( ffffffff ) g
  "   ││└ 2Il) ┘│││││└ Il) ┘│││││└ I) ┘│││││└ In) ┘│││││└ 2In) ┘│││
  "   │└─ 2il) ─┘│││└─ il) ─┘│││└─ i) ─┘│││└─ in) ─┘│││└─ 2in) ─┘││
  "   ├── 2al) ──┘│├── al) ──┘│├── a) ──┘│├── an) ──┘│├── 2an) ──┘│
  "   └── 2Al) ───┘└── Al) ───┘└── A) ───┘└── An) ───┘└── 2An) ───┘

  " a ( b ( cccccccc ) d ) ( e ( ffffff ) g ) ( h ( iiiiiiii ) j ) k
  "   │││ ││└ 2Il) ┘││││││││││ ││└ I) ┘││││││││││ ││└ 2In) ┘│││││││
  "   │││ │└─ 2il) ─┘│││││││││ │└─ i) ─┘│││││││││ │└─ 2in) ─┘││││││
  "   │││ ├── 2al) ──┘││││││││ ├── a) ──┘││││││││ ├── 2an) ──┘│││││
  "   │││ └── 2Al) ───┘│││││││ └── A) ───┘│││││││ └── 2An) ───┘││││
  "   ││└───── Il) ────┘│││││└─── 2I) ────┘│││││└───── In) ────┘│││
  "   │└────── il) ─────┘│││└──── 2i) ─────┘│││└────── in) ─────┘││
  "   ├─────── al) ──────┘│├───── 2a) ──────┘│├─────── an) ──────┘│
  "   └─────── Al) ───────┘└───── 2A) ───────┘└─────── An) ───────┘

  " Quote Mappings
  " i'  i"  i`    in' in" in`    il' il" il`
  " a'  a"  a`    an' an" an`    al' al" al`
  " I'  I"  I`    In' In" In`    Il' Il" Il`
  " A'  A"  A`    An' An" An`    Al' Al" Al`

  " a ' bbbbbbb ' c ' dddddd ' e ' fffffff ' g
  "   ││└ Il' ┘│││  ││└ I' ┘│││  ││└ In' ┘│││
  "   │└─ il' ─┘││  │└─ i' ─┘││  │└─ in' ─┘││
  "   ├── al' ──┘│  ├── a' ──┘│  ├── an' ──┘│
  "   └── Al' ───┘  └── A' ───┘  └── An' ───┘

  " Separator Mappings
  " i,  i.  i;  i:  i+  i-  i=  i~  i_  i*  i#  i/  i|  i\  i&  i$
  " a,  a.  a;  a:  a+  a-  a=  a~  a_  a*  a#  a/  a|  a\  a&  a$
  " I,  I.  I;  I:  I+  I-  I=  I~  I_  I*  I#  I/  I|  I\  I&  I$
  " A,  A.  A;  A:  A+  A-  A=  A~  A_  A*  A#  A/  A|  A\  A&  A$

  " in, in. in; in: in+ in- in= in~ in_ in* in# in/ in| in\ in& in$
  " an, an. an; an: an+ an- an= an~ an_ an* an# an/ an| an\ an& an$
  " In, In. In; In: In+ In- In= In~ In_ In* In# In/ In| In\ In& In$
  " An, An. An; An: An+ An- An= An~ An_ An* An# An/ An| An\ An& An$

  " il, il. il; il: il+ il- il= il~ il_ il* il# il/ il| il\ il& il$
  " al, al. al; al: al+ al- al= al~ al_ al* al# al/ al| al\ al& al$
  " Il, Il. Il; Il: Il+ Il- Il= Il~ Il_ Il* Il# Il/ Il| Il\ Il& Il$
  " Al, Al. Al; Al: Al+ Al- Al= Al~ Al_ Al* Al# Al/ Al| Al\ Al& Al$

  " a , bbbbbbbb , ccccccc , dddddd , eeeeeee , ffffffff , g
  "   ││└ 2Il, ┘│││└ Il, ┘│││└ I, ┘│││└ In, ┘│││└ 2In, ┘│ │
  "   │└─ 2il, ─┤│├─ il, ─┤│├─ i, ─┤│├─ in, ─┤│├─ 2in, ─┤ │
  "   ├── 2al, ─┘├┼─ al, ─┘├┼─ a, ─┘├┼─ an, ─┘├┼─ 2an, ─┘ │
  "   └── 2Al, ──┼┘        └┼─ A, ──┼┘        └┼─ 2An, ───┘
  "              └─  Al,  ──┘       └─  An,  ──┘

  " Argument Mappings
  " ia  aa  Ia  Aa
  " ina ana Ina Ana
  " ila ala Ila Ala

  " a ( bbbbbb , ccccccc , d ( eeeeee , fffffff ) , gggggg ) h
  "   ││├2Ila┘│││└─Ila─┘││││ ││├─Ia─┘│││└─Ina─┘│││││└2Ina┘│ │
  "   │└┼2ila─┘│├──ila──┤│││ │└┼─ia──┘│├──ina──┤│││├─2ina─┤ │
  "   │ └2ala──┼┤       ││││ │ └─aa───┼┤       │││├┼─2ana─┘ │
  "   └──2Ala──┼┘       ││││ └───Aa───┼┘       │││└┼─2Ana───┘
  "            ├───ala──┘│││          ├───ana──┘││ │
  "            └───Ala───┼┤│          └───Ana───┼┤ │
  "                      ││└─────2Ia────────────┘│ │
  "                      │└──────2ia─────────────┤ │
  "                      ├───────2aa─────────────┘ │
  "                      └───────2Aa───────────────┘

  "}}}

  "taskwiki {{{
    " :TW # launches TaskWiki
    " <leader>t ...
    "   <CR> info           | a    annotate   | bd   burndown daily | bw   burndown weekly | bm   burndown monthly |
    "   cp   choose project | ct   choose tag | C    calendar       | d    done            | D    Delete           |
    "   e    edit           | g    grid       | Gm   ghistory month | Ga   ghistory annual | hm   history month    |
    "   ha   history annual | i    info       | l    back-link      | m    modify          | p    projects         |
    "   s    summary        | S    stats      | t    tags           | +    start           | -    stop             |

  "}}}

  "tcomment_vim {{{

  "}}}

  " undotree {{{
  " nnoremap <F5> :UndotreeToggle<CR>
  if !exists('g:undotree_WindowLayout')
      let g:undotree_WindowLayout = 2
  endif

  "}}}

  " vimade {{{
  " let g:diminactive_enable_focus = 1
  let g:vimade = {
    \ "fadelevel" : 0.7,
    \ }

  "}}}

  "VimCompletesMe {{{
  " NOTE: It's important to understand that this plugin builds upon vim's own ins-completion
  " inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " NOTE: For some reason, even with this enabled, using <CR> causes a new line to be inserted.
    " What's interesting, though, is that this *DOES* seem to work if you use it within this vimrc
    " file. But the moment you step out into, say, your land_app window, it goes back to inserting
    " a carriage return. How strange...
    " UPDATE: Turns out this was due to the lexima plugin!

  "}}}

  "vim-abolish {{{
  " :Subvert/<word>/<word>/g
  "   The catch though is that you can add variants with {}. For example

  "     :%Subvert/facilit{y,ies}/building{,s}/g
  "
  "   This would change facility to building as well as facilities to buildings.

  "}}}

  "vim-asciidoctor {{{
  function! AsciidoctorMappings()
      " nnoremap <buffer> <leader>oo :AsciidoctorOpenRAW<CR>
      nnoremap <buffer> <leader>op :AsciidoctorOpenPDF<CR>
      nnoremap <buffer> <leader>oh :AsciidoctorOpenHTML<CR>
      " nnoremap <buffer> <leader>ox :AsciidoctorOpenDOCX<CR>
      nnoremap <buffer> <leader>ch :Asciidoctor2HTML<CR>
      nnoremap <buffer> <leader>cp :Asciidoctor2PDF<CR>
      " nnoremap <buffer> <leader>cx :Asciidoctor2DOCX<CR>
      nnoremap <buffer> <leader>p :AsciidoctorPasteImage<CR>
      " :make will build pdfs
      compiler asciidoctor2pdf

  endfunction

  augroup asciidoctor
    au!
    au BufEnter *.adoc,*.asciidoc call AsciidoctorMappings()

  augroup END

  "}}}

  "vim-closetag {{{
  let g:closetag_filenames = '*.html, *.html.erb, *.xhtml, *.phtml, *.vue'
  let g:closetag_emptyTags_caseSensitive = 1
  let g:closetag_shortcut = '>'
  let g:closetag_close_shortcut = '<leader>>'

  "}}}

  "vim-coffee-script {{{
  " :CoffeeCompile # shows how current snippet/file is compiled to JavaScript
  " :CoffeeRun # run code snippet
  " :CoffeeWatch # live code compiling preview
  map <silent><leader>cr :CoffeeRun<CR>
  map <silent><leader>cw :CoffeeWatch<CR>

  "}}}

  "vim-commentary {{{
  " https://github.com/tpope/vim-commentary/issues/15
  " https://github.com/tpope/vim-commentary/issues/124
  " :set filetype?
  " :set commentstring?
  " :verbose set commentstring?
  " :scriptnames
  " setglobal commentstring=#\ %s
  augroup comments
    autocmd!
    autocmd FileType vim setlocal commentstring=\"\ %s
  augroup END

  "}}}

  "vim-dirvish {{{
  " At the outset, just know that dirvish is built around vim's featureset. So rather than have
  " a special mapping for, say, creating a new file, dirvish opts instead for tying with vim's own
  " `:e` command.
  "
  " -  # open current file directory
  " gq # close and return to previously active file
  " p  # preview file
    " NOTE: If you are running vim-dirvish-dovish, this p mapping is likely set to something else
  " :e %file.txt # create new file in current directory
  " :!mkdir %directory # create new directory in current directory

  "}}}

  "vim-dirvish-dovish {{{
  " NOTE: below remappings taken from repo notes
  " unmap all default mappings
  " let g:dirvish_dovish_map_keys = 0

  " unmap dirvish default
  " unmap <buffer> p

  " Your preferred mappings
  " nmap <silent><buffer> i <Plug>(dovish_create_file)
  " nmap <silent><buffer> I <Plug>(dovish_create_directory)
  " nmap <silent><buffer> dd <Plug>(dovish_delete)
  " nmap <silent><buffer> r <Plug>(dovish_rename)
  " nmap <silent><buffer> yy <Plug>(dovish_yank)
  " xmap <silent><buffer> yy <Plug>(dovish_yank)
  " nmap <silent><buffer> p <Plug>(dovish_copy)
  " nmap <silent><buffer> P <Plug>(dovish_move)

  "}}}

  "vim-easymotion {{{
  " NOTE: Default key is <leader><leader> then a <motion> key like w, e, b, etc
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_use_smartsign_us = 1

  " custom key mappings --------
  " NOTE: Whenever I try to use a single <leader>, it doesn't ever seem to work for some reason...
  " let g:EasyMotion_do_mapping = 0 " disable default mappings
  " nmap <leader><w>   <Plug>(easymotion-w)
  " nmap <leader><e>   <Plug>(easymotion-e)
  " nmap <leader><b>   <Plug>(easymotion-b)
  " nmap <leader><S-l> <Plug>(easymotion-overwin-line)
  " nmap <leader><s>   <Plug>(easymotion-overwin-f)

  "}}}

  " vim-fugitive {{{
    " :Gstatus
    " :Gcommit
    " :Gread
    " :Gwrite
    " :Gmove
    " :Gremove
    " :Glog
    " :Gdiff
    " :Gblame
    " :Gbrowse

  "}}}

  "vim-gitgutter {{{
  let g:gitgutter_max_signs = 500
  let g:gitgutter_highlight_lines = 0
  let g:gitgutter_eager = 0
  let g:gitgutter_realtime = 0

  " ]c # next  git change hunk
  " [c # previous git change hunk

  " NOTE: A recent change links the color settings to the Diff* highlight settings, the below sets
  " them back to their 'original' defaults. If you ever want to have them match up with the
  " colorscheme you're currently using, the following command may be of some use
  " UPDATE: From what I can tell, this issue seems to affect the spacegray scheme, others don't have
  " any issue...
  " `:verbose highlight DiffAdd` in vim
  " highlight GitGutterAdd guifg=#009900 ctermfg=2 ctermbg=65
  " highlight GitGutterChange guifg=#bbbb00 ctermfg=3 ctermbg=65
  " highlight GitGutterDelete guifg=#ff2222 ctermfg=1 ctermbg=65

  "}}}

  "vim-hexokinase {{{
    let g:Hexokinase_highlighters = ['backgroundfull']

    let g:Hexokinase_ftOptInPatterns = {
    \     'css': 'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names',
    \     'scss': 'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names',
    \     'html': 'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names',
    \     'vue': 'full_hex,triple_hex,rgb,rgba,hsl,hsla,colour_names'
    \ }

  "}}}

  " vim-floaterm {{{
    let g:floaterm_type = 'popup'
    " let g:floaterm_wintype = 'popup'
    " let g:floaterm_width = 0.8
    " let g:floaterm_height = 0.8

  "}}}

  "vim-gutentags {{{
  augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
  augroup END

  let g:gutentags_ctags_exclude = ['*vendor', '*node_modules', '*coverage']

  "}}}

  " vim-hardtime {{{
  let g:hardtime_default_on = 1
  let g:hardtime_timeout = 2000 " in ms

  "}}}

  "vim-indent-guides {{{
  " :h indent_guides " Contains how to change colors
  map <silent><leader><leader><tab> :IndentGuidesToggle<CR>
  let g:indent_guides_enable_on_vim_startup = 0
  let g:indent_guides_start_level = 2
  let g:indent_guides_guide_size = 2

  "}}}

  "vim-instant-markdown {{{
  let g:instant_markdown_slow = 1
  let g:instant_markdown_autostart = 0 " enable to prevent autolaunch of preview window
  map <leader>md :InstantMarkdownPreview<CR>

  "}}}

  "vim-jsx {{{
  let g:jsx_ext_required = 1 " by default it runs on both .jsx and .js files. If you want it to only
  "   run on .jsx, set to 1

  "}}}

  "vim-latex-live-preview {{{
  let g:livepreview_cursorhold_recompile = 0

  "}}}

  " vim-macrobatics {{{
    nmap gp <plug>(Mac_Play)
    nmap gr <plug>(Mac_RecordNew)

    " You use this a bit differently compared to vim's default macro setup. For example, rather than
    " always having to specify a register like default vim, with macrobatics, the macro is always
    " saved to the same register unless one is provided. So for example...
    "
    "   `gr` starts the recording process, you do your thing, then press `gr` again to stop recording
    "   `gp` plays it back
    "
    " If you wanted to save it as, say, `x`, you'd do it like this:
    "
    "   `xgr` ... `xgr`
    "   `xgp`

  "}}}

  " vim-markbar {{{
  nmap <leader>m <Plug>ToggleMarkbar

  "}}}

  "vim-markdown-preview {{{
  " NOTE: I'm not quite sure why the readme uses 'let xyz' vs 'let g:xyz'
  "
  " let vim_markdown_preview_hotkey = '<C-m>' " default '<C-p>'
  " NOTE: only activate one of the below, default 0
  " let vim_markdown_preview_toggle = 0 " on hotkey, no images
  " let vim_markdown_preview_toggle = 1 " on hotkey, with images
  let vim_markdown_preview_toggle = 2 " on buffer write, with images
  " let vim_markdown_preview_toggle = 3 " on buffer write, no images

  "}}}

  " vim-mergetool {{{
  " Launch with :MergetoolStart
  " Quit with :MergetoolStop
  "
  let g:mergetool_layout = 'mr' "
  "   m = local
  "   r = remote
  "   b = base.
  " Use a comma to denote horizontal split. So for example,
  "
  "   `mr,b`
  "
  " would put the local and remote side by side with the base shown at the bottom in a horizontal
  " split
  "
  " let g:mergetool_prefer_revision = 'local'
  "   NOTE: This setting will allow the mergetool to 'autoselect' a certain side of the coin upon
  "   launch without any user input. Another way to achieve something similar without having to set
  "   this hear, launch the plugin with either
  "   :MergetoolPreferLocal or :MergetoolPreferRemote

  "}}}

  "vim-minimap {{{
  let g:minimap_toggle='<leader>mm'
  let g:minimap_update='<leader>mu'

  "}}}

  " vim-mundo {{{
  nnoremap <F5> :MundoToggle<CR>

  "}}}

  "vim-peekaboo {{{
  let g:peekaboo_compact = 1 " default 0

  "}}}

  "vim-pomodoro {{{
  " :PomodoroStart [pomodoro_name] " command to start
  map <leader>ps :PomodoroStart<CR>
  let g:pomodoro_time_work = 25
  let g:pomodoro_time_slack = 5
  let g:pomodoro_do_log = 0
  let g:pomodoro_log_file = "/tmp/pomodoro.log"
  "set statusline=%#ErrorMsg#%{PomodoroStatus()}%#StatusLine# " displays in statusline
  let g:pomodoro_notification_cmd = 'zenity --notification --text="Pomodoro Finished"'

  "}}}

  "vim-prettier {{{
  ":PretterVersion to check install
  let g:prettier#exec_cmd_async = 1 " run asyncronously rather than the default (syncronously)
  map <leader>p :Prettier<CR>

  " By default, prettier will only run on files that have the string '@format' commented out at the
  " top of the file. Setting the below to 0 makes it so that this is not required, allowing it to run
  " on any files with the below listed extensions, depending on whichever file set you've chosen to
  " uncomment.
  let g:prettier#autoformat = 1

  " augroup Prettier
  "   autocmd!
  "   autocmd BufWritePre *.js,*.jsx,*.css,*.less,*.scss,*.json,*.graphql,*.md Prettier
  "   autocmd BufWritePre *.js,*.jsx,*.css,*.less,*.scss,*.json,*.graphql, Prettier
  "   autocmd BufWritePre *.js,*.jsx,*.css,*.less,*.json,*.graphql, Prettier
  " augroup end

  " NOTE: If there is a bit of code that you do NOT want prettier to spruce up for you -- for example,
  " if you don't care for the format it comes up with or something -- add the comment `//
  " prettier-ignore` just above that node and it will be omitted from any fixins. The proper comment
  " syntax will obviously differ depending on the file of file you're dealing with, but
  " prettier-ignore is what you're after

  let g:prettier#quickfix_enabled = 0 " disable quickfix window from popping up when errors are found

  " Formatting settings {{{
  "
  " max line length that prettier will wrap on
  " Prettier default: 80
  " let g:prettier#config#print_width = 80
  let g:prettier#config#print_width = 125

  " number of spaces per indentation level
  " Prettier default: 2
  let g:prettier#config#tab_width = 2

  " use tabs over spaces
  " Prettier default: false
  let g:prettier#config#use_tabs = 'false'

  " print semicolons
  " Prettier default: true
  let g:prettier#config#semi = 'true'

  " single quotes over double quotes
  " Prettier default: false
  let g:prettier#config#single_quote = 'true'

  " print spaces between brackets
  " Prettier default: true
  let g:prettier#config#bracket_spacing = 'false'

  " put > on the last line instead of new line
  " Prettier default: false
  let g:prettier#config#jsx_bracket_same_line = 'true'

  " avoid|always
  " Prettier default: avoid
  let g:prettier#config#arrow_parens = 'always'

  " none|es5|all
  " Prettier default: none
  let g:prettier#config#trailing_comma = 'all'

  " flow|babylon|typescript|css|less|scss|json|graphql|markdown
  " Prettier default: babylon
  let g:prettier#config#parser = 'flow'

  " cli-override|file-override|prefer-file
  let g:prettier#config#config_precedence = 'prefer-file'

  " always|never|preserve
  let g:prettier#config#prose_wrap = 'preserve'

  "}}}

  "}}}

  "vim-rails {{{
  " see :h rails-navigation
  "     :h rails-exec
  "     :h rails-default-task
  "     :h rails-:Extract
  "     :h rails-integration
  "
  " gf # go to related file under cursor. For example if you `gf` while over Post.first takes you to
  "   the models/post.rb file
  "
  " :A # Alternate
  " :R # Related

  " :E<filetype> # Edit
  "   model
  "   view
  "   controller
  "
  " :Rails <command> # This essentially starts a new console instance and runs the equivalent
  "
  "   `$ rails <command>`

  "}}}

  "vim-ripgrep {{{

  "}}}

  " vim-rubocop {{{
  " :Rubocop <options> " available options are the same as those found in standard Rubocop

  "}}}

  "vim-signify {{{
  " :h signify-modus-operandi

  "}}}

  "vim-sneak {{{
  " s<char><char> # starts sneak mode FORWARD on two letter match
  " S<char><char> # starts sneak mode BACKWARD on two letter match
  " s<char><CR>   # starts sneak mode FORWARD on single letter match
  " S<char><CR>   # starts sneak mode BACKWARD on single letter match
  " s<CR>         # repeats last search
  " ;             # next
  " ,             # previous
  " ``/<CRTL-O>   # go back to start of the search 'queue'
  " <Space>       # leave sneak mode where the cursor is positioned

  let g:sneak#s_next = 1 " sneak-clever-s, allows s/S to act as next/prev
  let g:sneak#label = 1 " uses a mode similar to easymotion

  "}}}

  "vim-sort-motion {{{
  " gs + motion
  "   gs2j # sort the current line + two lines down
  "   gsip # sort current paragraph
  "   gsii # sort current indentation level (requires text-obj-indent plugin)
  "   gsi( # sort within parentheses, or at least try to
  "
  " In visual mode, with rows selected, simply use `gs` to run the vim-sort

  "}}}

  "vim-sort-folds {{{
  "  visually select the folds you'd like to sort, then run
  "    :call sortfolds#SortFolds()
  "
  "  <leader>sf # default visual mapping, but I haven't been able to get it to work.

  "}}}

  "vim-sandwich {{{
  " sa<select_text_object><new_surround> # add surrounding
  " sd<current_surround> # delete surrounding
  " sr<curround_surround><new_surround> # replace surrounding
  "
  " ib / ab # search and select sandwiched text automatically
  " is / as # search and select sandwitched text with query

  "}}}

  "vim-surround {{{
  " First, how to activate it
  "   Normal mode
  "     ys<select_text_object><new_surround> # add a surrounding
  "       ysiw" # Adds quotes around the cursored word, ys + <inside object> + <word>
  "         NOTE: See your text-objects in .reference for what is available per vim
  "     ds<current_surround> # delete a surrounding, enter target, ex. `ds"` to remove quotes
  "     cs<current_surround><new_surround> # 'change surrounding', example: `cs])`
  "     yss # add a surrounding to a whole line
  "     ySS # add a surrounding to a whole line, pad it on new lines with indents
  "   Visual mode
  "     NOTE: In practice, I find that s goes into some weird delete then insert mode while
  "     S surrounds the selection S # add a surrounding to selection. This can be really useful when
  "     combined with vim motions. So say you want to visually select an entire sentence and add
  "     double quotes around it. `visS"`
  "       NOTE: This differs from what's stated in the manual (below)
  "         s # add a surrounding
  "         S # add a surrounding to a whole line, pad it on new lines with indents
  "   Insert mode
  "     <C-s>
  "
  " Now for the commands you can pass in after you activate it...
  "   Pretty much every symbol works as you'd expect it to. " for quotes, ( for parens, [ for
  "   brackets, etc
  "   For every symbol, if you use the 'open/left-side' version, a space will be inserted, if you use
  "   the 'close/right-side' version, no space will be inserted
  "
  "   There are some odd-balls though. Here are some that deal with Ruby
  "     Insert Mode + <C-s> +
  "       =   <%= %>
  "       -   <%  %>
  "       #   <%# %>
  "
  "}}}

  "vim-system-copy {{{
  " cp + motion or text object
  "   cpiw # copy word
  "   cpi' # copy inside single quotes
  "   cP   # copy current line
  "
  " cv # paste clipboard content to the next line
  "
  "}}}

  "vim-test {{{
  nnoremap <silent> <leader>t :TestNearest<CR>
  nnoremap <silent> <leader>T :TestFile<CR>
  nnoremap <silent> <leader>a :TestSuite<CR>
  nnoremap <silent> <leader>l :TestLast<C-r>

  let test#ruby#minitest#options = '--verbose'

  "}}}

  "vimtex {{{
  let g:vimtex_view_method="zathura"

  "}}}

  "vim-eunuch {{{
  " :Delete
  " :Mkdir
  " :Move
  " :Rename

  "}}}

  "vim-tmux-focus-events {{{
  " NOTE: The below is intended to fix the Alt-Tab character insertion issues. Though I still see it
  " happening from time to time...
  exec "set <F24>=\<Esc>[0"
  exec "set <F25>=\<Esc>[I"
  au FocusGained * silent redraw!

  "}}}

  "vim-tmux-navigator {{{
  " Disable tmux navigator when zooming the Vim pane
  let g:tmux_navigator_disable_when_zoomed = 1

  "}}}

  "vim-veil {{{
  nmap <F12> <Plug>Veil

  "}}}

  "vim-vinegar {{{
  " -  # open vinegar. Once open, hop up to directory listing
    " NOTE: Enable the following mappings if you DON'T want vinegar to use the - key
    " nmap <silent><leader>- <Plug>VinegarUp
    " nnoremap - -
  " ~  # open $HOME directory
  " I  # toggle banner
  " gh # Toggle hidden files
  " y. # yank absolute filepath for file under cursor
  " ~  # go back to original location

  "}}}

  "vim-windowswap {{{
  " Run command on window you'd like to move, then change to the window you want to swap with, and
  " run command again. Boom!
  nnoremap <silent> <leader>sw :call WindowSwap#EasyWindowSwap()<CR>

  "}}}

  "vim-wordmotion {{{
  " let g:wordmotion_prefix = '<Space>' " this means you activate the camel/snake jump with <Space>,
  " ala c<Space>w, for example
  "   NOTE: Be advised this introduces a timeout pause when using <space> to open/close folds per your
  "   custom mapping. This is because vim-wordmotion is 'waiting' to see if a motion will proceed
  "   before allowing the default fold operation to complete

  "}}}

  "vim-workspace {{{
  " NOTE: If the Session.vim file did not get loaded in for some reason, all you have to do is
  " source it from within vim:
  "
  "   :so Sesssion.vim

  nnoremap <leader>W :ToggleWorkspace<CR>
  let g:workspace_autocreate = 1 " auto create Session.vim file if none exists
  let g:workspace_session_disable_on_args = 1 " Session will not load if launching with $ vim <file>
  let g:workspace_autosave_untrailspaces = 1
  let g:workspace_persist_undo_history = 0
  let g:workspace_autosave = 0 " some find this unnecessary given linux's use of swap files, also
  "  knock it for putting unecessary strain on system drives for the near constant stream of saves.
  "  NOTE: To this point, however, it should be kept in mind that you might have swap files disabled
  "  here in your .vimrc

  "Add files you do not want autosaved and autotrimmed to the following array
  let g:workspace_autosave_ignore = ['gitcommit']

  let g:workspace_nocompatible = 0 " prevents plugin from overriding certain .vimrc settings. In my
  "  case, it was overriding my `set noshowmode` setting to `set showmode`

  let g:workspace_session_name = 'Session_vim.vim'

  "}}}

  "vimwiki {{{
  " <leader>ww is the default keybind for 'starting' vimwiki by launching your base index.wiki file
  nnoremap <leader>vw :VimwikiIndex<CR>
  "NOTE: It has a pretty slick diary mode if you're ever needing something like that...
  let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
  let g:vimwiki_folding='' " <blank>, expr, syntax, list
    " NOTE: Evidently vimwiki will use whatever you set vim's fold settings to if you leave this
    " setting as '' (ie blank). So in order to have vimwiki respond to manual fold settings like
    " I have in vim, leaving it blank seemed to do the trick when vim's fold setting is set to marker

  "}}}

  "zoom-win {{{
  " Default is <C-w>o
  " nnoremap <silent> <C-w>0 :ZoomWin<CR>

  "}}}

  "}}}

endif

" }}}

" neovim {{{
if has('nvim')
" setup {{{
    " https://github.com/junegunn/vim-plug/issues/739
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
      silent execute "!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

      " Updated 20201010
      " https://github.com/junegunn/vim-plug
      " silent execute "!curl -fLo '${XDG_DATA_HOME:-$HOME/.local/share}'/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
      " NOTE: if the above doesn't work, then run the following command manually in the terminal:
      " curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

      augroup PlugNeovim
        autocmd!
        autocmd VimEnter * PlugInstall | source $MYVIMRC
      augroup END

    endif

" }}}

" Plugins {{{
call plug#begin()
  " lsp related
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'neovim/nvim-lspconfig'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'williamboman/nvim-lsp-installer/'

  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'jiangmiao/auto-pairs'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim' ", { 'on': '<Plug>Gfiles' }
  Plug 'justinmk/vim-sneak' " a different take on easymotion, a LOT smaller
  Plug 'kylechui/nvim-surround'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'sheerun/vim-polyglot' " collection of language packs, loads on demand
  Plug 'thaerkh/vim-workspace' " automated session management and file auto-save
  Plug 'tpope/vim-endwise' " adds end when starting a block
  Plug 'tpope/vim-commentary' ", { 'on': '<Plug>Commentary' }

  "Plug 'ggandor/lightspeed.nvim'
  Plug 'mfussenegger/nvim-dap'

  " NvChad recommends
  " Plug 'akinsho/bufferline.nvim'
  " Plug 'folke/which-key.nvim'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'kyazdani42/nvim-web-devicons'
  " Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'NvChad/extensions'
  Plug 'NvChad/nvterm'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    " NOTE: If the 'do' command fails here, simply relaunch and run `:TSUpdate all`
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'windwp/nvim-autopairs'

"colorschemes ----------------{{{
"http://colorswat.ch
"http://vimcolors.com
"https://vimcolorschemes.com

" Plug 'zefei/vim-colortuner'
"   NOTE: not compatible with terminal vim

" Plug 'aditya-azad/candle-grey'
Plug 'ajgrf/parchment'
" Plug 'ajh17/spacegray.vim'
" Plug 'https://gitlab.com/aimebertrand/timu-spacegrey.git'
" Plug 'AlessandroYorba/Alduin'
  " NOTE: Nice, but maybe a *slightly* bit too high contrast
" Plug 'AlessandroYorba/Despacio'
" Plug 'AlessandroYorba/Sierra'
Plug 'altercation/vim-colors-solarized'
Plug 'andreypopp/vim-colors-plain'
Plug 'arcticicestudio/nord-vim'
Plug 'arzg/vim-substrata'
" Plug 'axvr/photon.vim'
Plug 'ayu-theme/ayu-vim'
" Plug 'baeuml/summerfruit256.vim'
Plug 'barlog-m/oceanic-primal-vim'
" Plug 'bluz71/vim-nightfly-guicolors'
" Plug 'bluz71/vim-moonfly-colors'
" Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
Plug 'chriskempson/base16-vim'
Plug 'cideM/yui'
Plug 'clinstid/eink.vim'
" Plug 'cocopon/iceberg.vim'
" Plug 'cocopon/lightline-hybrid.vim'
" Plug 'co1ncidence/mountaineer.vim'
"   NOTE: user got banned from github
Plug 'danishprakash/vim-yami'
Plug 'davidosomething/vim-colors-meh'
" Plug 'desmap/slick'
Plug 'deviantfero/wpgtk.vim'
Plug 'dikiaap/minimalist'
" Plug 'dracula/vim'
" Plug 'drewtempelmeyer/palenight.vim'
" Plug 'duckwork/nirvana'
" Plug 'duckwork/low.vim'
" Plug 'dylanaraps/wal.vim'
" Plug 'easysid/mod8.vim'
" Plug 'felipec/vim-felipec'
" Plug 'habamax/vim-polar'
Plug 'habamax/vim-alchemist'
Plug 'hardselius/warlock'
" Plug 'Haron-Prime/Antares'
" Plug 'hhff/SpacegrayEighties.vim'
" Plug 'jaredgorski/spacecamp'
Plug 'jaredgorski/fogbell.vim'
Plug 'JaySandhu/xcode-vim'
" Plug 'Jorengarenar/vim-colors-B_W'
" Plug 'joshdick/onedark.vim'
" Plug 'jnurmine/Zenburn'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Plug 'KeitaNakamura/neodark.vim'
" Plug 'keith/parsec.vim'
Plug 'karoliskoncevicius/distilled-vim'
" Plug 'karoliskoncevicius/sacredforest-vim'
Plug 'kristijanhusak/vim-hybrid-material'
Plug 'lifepillar/vim-solarized8' " optimized version of solarized
Plug 'logico/typewriter-vim'
Plug 'Lokaltog/vim-monotone'
" Plug 'mhartington/oceanic-next'
" Plug 'morhetz/gruvbox'
  Plug 'gruvbox-community/gruvbox'
  " NOTE: This forked repo is meant to be better maintained than the original
  Plug 'habamax/vim-gruvbit' " slightly different colorings here and there
  Plug 'lifepillar/vim-gruvbox8' " an optimized take on gruvbox
  Plug 'sainnhe/gruvbox-material'
  " NOTE: modified gruvbox theme to soften some contrasts and better eliminate blue-light colors
" Plug 'mountain-theme/Mountain'
Plug 'pradyungn/Mountain', {'rtp': 'vim'}
Plug 'mswift42/vim-themes'
" Plug 'nanotech/jellybeans.vim'
" Plug 'nightsense/snow'
Plug 'NLKNguyen/papercolor-theme'
" Plug 'ntk148v/vim-horizon'
Plug 'olivertaylor/vacme'
" Plug 'overcache/NeoSolarized'
" Plug 'patstockwell/vim-monokai-tasty'
Plug 'pbrisbin/vim-colors-off'
Plug 'pgdouyon/vim-yin-yang'
" Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'
" Plug 'rakr/vim-one'
Plug 'rakr/vim-two-firewatch'
" Plug 'rj-white/vim-colors-paramountblue'
" Plug 'https://gitlab.com/rj-white/waterfall.vim'
" Plug 'rhysd/vim-color-spring-night'
" Plug 'romainl/flattened'
" Plug 'sainnhe/forest-night'
Plug 'smallwat3r/vim-simplicity'
" Plug 'sonph/onehalf'
" Plug 'steveno/mavi'
" Plug 't184256/vim-boring'
Plug 'therubymug/vim-pyte'
" Plug 'tomasr/molokai'
" Plug 'trevordmiller/nova-vim'
Plug 'tyrannicaltoucan/vim-quantum'
" Plug 'vim-scripts/Blueshift'
" Plug 'vim-scripts/EditPlus'
" Plug 'wadackel/vim-dogrun'
" Plug 'w0ng/vim-hybrid'
Plug 'YorickPeterse/vim-paper'
" Plug 'zekzekus/menguless'

" Yay but nay, for various reasons.
" Plug 'godlygeek/csapprox' " helps properly display theme colors, including backgrounds
" Plug 'andreasvc/vim-256noir'
" Plug 'atelierbram/Base2Tone-vim'
" Plug 'axvr/photon.vim'
" Plug 'badacadabra/vim-archery'
" Plug 'ciaranm/inkpot'
" Plug 'dikiaap/minimalist'
" Plug 'doums/darcula'
" Plug 'fenetikm/falcon'
" Plug 'flrnprz/candid.vim'
" Plug 'https://gitlab.com/ducktape/monotone-termnial.git'
" Plug 'hardcoreplayers/oceanic-material'
" Plug 'huyvohcmc/atlas.vim'
" Plug 'endel/vim-github-colorscheme'
" Plug 'ewilazarus/preto'
" Plug 'flazz/vim-colorschemes' " A collection with a TON of colorschemes
" Plug 'fxn/vim-monochrome'
" Plug 'gilgigilgil/anderson.vim'
" Plug 'gosukiwi/vim-atom-dark'
" Plug 'jacoborus/tender.vim'
" Plug 'jonathanfilip/vim-lucius'
" Plug 'junegunn/seoul256.vim'
" Plug 'KimNorgaard/vim-frign'
" Plug 'KKPMW/oldbook-vim'
" Plug 'lifepillar/vim-wwdc16-theme'
" Plug 'Lokaltog/vim-distinguished'
" Plug 'LuRsT/austere.vim'
" Plug 'marcopaganini/termschool-vim-theme'
" Plug 'mhinz/vim-janah'
" Plug 'nightsense/carbonized'
" Plug 'noahfrederick/vim-hemisu'
" Plug 'owickstrom/vim-colors-paramount'
" Plug 'quanganhdo/grb256'
" Plug 'reedes/vim-colors-pencil'
" Plug 'reedes/vim-thematic'
" Plug 'robertmeta/nofrils'
" Plug 'romainl/Apprentice'
" Plug 'shinchu/lightline-gruvbox.vim'
" Plug 'sjl/badwolf'
" Plug 'smallwat3r/vim-efficient'
" Plug 'smallwat3r/vim-simplicity'
" Plug 'szorfein/fantasy.vim'
" Plug 't184256/vim-boring'
" Plug 'tpope/vim-vividchalk'
" Plug 'tyrannicaltoucan/vim-deep-space'
" Plug 'vim-scripts/The-Vim-Gardener'
" Plug 'vim-scripts/256-grayvim'
" Plug 'xero/blaquemagick.vim'
" Plug 'xstrex/FireCode.vim'
" Plug 'YorickPeterse/happy_hacking.vim'
" Plug 'zefei/simple-dark'

"}}}

call plug#end()

" }}}

"plugin settings {{{
lua << EOF
  function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
      options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end

  --map("i", "<Tab>", "<Cmd>lua require('cmp').complete()<CR>")
  map("i", "^p", "<Cmd>lua require('cmp').complete()<CR>")

EOF

" gitsigns "{{{
lua << EOF
-- require('gitsigns').setup()
require('gitsigns').setup{
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})
  end


}

EOF

"}}}

" initial neovim lsp stuff, recommended 'at top of file' {{{
lua << EOF
  -- Setup lspconfig
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

EOF

" }}}

  "FZF {{{
  " NOTE: Any fzf related command that is ended with an exclamation point will open it in fullscreen
  " mode In practice, I've found this causes less conflict with colorschemes not displaying properly

  " nnoremap <C-p> :FZF<CR>
  " nnoremap <C-p> :GFiles<CR>
  nnoremap <C-p> :GFiles!<CR>
    " NOTE: Changed default command to :GFiles so it would respect the .gitignore setup and not pull
    " in results from places like node_modules, etc
  " nnoremap <C-b> :Buff<CR>
  nnoremap <C-b> :Buff!<CR>
  " nnoremap <C-m> :Marks<CR>
  nnoremap <C-m> :Marks!<CR>
  nnoremap <C-e> :FZF!<CR>

  nmap     <C-s> :Ag!<SPACE>
  nnoremap <C-s> :Ag!<SPACE>
  " nmap     <C-s> :Rg<SPACE>
  " nnoremap <C-s> :Rg<SPACE>

  " https://github.com/junegunn/fzf
  " <1> <2>        # fuzzy match that contains both <1> and <2>, add space between the search terms
  " '<wild>        # wildcard
  " ^<prefix>      # items that start with <prefix>
  " .<suffix>      # items that end with <suffix>
  " !<not>         # items that do NOT include <not>
  " !^<not-prefix> # items that do not start with <not-prefix>
  " !.<not-suffix> # items that do not end with <not-suffix>

  " https://github.com/junegunn/fzf.vim#commands
  "   :Buff<CR> # search through buffer list
  "   :BTags # search for tags within buffer
  "   :Tags  # search for tags across entire project
  "   :Marks
  "   :Helptags # view a fzf-like searchable for vim's :help documentation. Wow!
  "   :Maps

  " classic style
  " let g:fzf_layout = { 'up': '~50%' }

  " popup style
  " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9, 'highlight': 'Todo', 'rounded': v:true } }
  let g:fzf_preview_window = '' " disables preview window altogether

  " let g:fzf_buffers_jump = 1 " This goes to the matching buffer, if open

  "}}}

" lsp related" {{{
lua << EOF
require'lspconfig'.gopls.setup{
  capabilities = capabilities,
  on_attach = function()
    print("hello from gopls")
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0}) --"go-to definition"
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, {buffer=0})
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer=0})
    vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, {buffer=0})
    vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, {buffer=0})
    vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {buffer=0})
    end,
}

require'lspconfig'.pyright.setup{}

local action_state = require('telescope.actions.state')
require('telescope').setup{
  defaults = {
    prompt_prefix = "$ ",
    mappings = {
      i = {
        ["<c-a>"] = function() print(vim.inspect(action_state.get_selected_entry())) end
      }
    }
  }
}

require('telescope').load_extension('fzf')

local mappings = {

}
mappings.curr_buf = function()
  local opt = require('telescope.themes').get_dropdown({height=10, previewer=false})
  require('telescope.builtin').current_buffer_fuzzy_find(opt)
end
return mappings

EOF

" }}}

" nvim-cmp related" {{{
lua <<EOF
  vim.opt.completeopt={"menu", "menuone", "noselect"}
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    --mapping = cmp.mapping.preset.insert({
    --  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --  ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --  ['<C-Space>'] = cmp.mapping.complete(),
    --  ['<C-e>'] = cmp.mapping.abort(),
    --  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --}),
    mapping = {
      --Taken from: https://dev.to/vonheikemen/neovim-lsp-setup-nvim-lspconfig-nvim-cmp-4k8e
      --['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      --['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),

      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({select = true}),

      ['<C-d>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, {'i', 's'}),

      ['<C-b>'] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {'i', 's'}),

      ['<Tab>'] = cmp.mapping(function(fallback)
        local col = vim.fn.col('.') - 1

        if cmp.visible() then
          cmp.select_next_item(select_opts)
        elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          fallback()
        else
          cmp.complete()
        end
      end, {'i', 's'}),

      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item(select_opts)
        else
          fallback()
        end
      end, {'i', 's'}),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    }),
    completion = {
      autocomplete = false
    }
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

EOF

" }}}

" nvim-surround {{{
lua << EOF
  require("nvim-surround").setup({
  -- config here
  })
EOF

" }}}

"vim-workspace {{{
" NOTE: If the Session.vim file did not get loaded in for some reason, all you have to do is
" source it from within vim:
"
"   :so Sesssion.vim

nnoremap <leader>W :ToggleWorkspace<CR>
let g:workspace_autocreate = 1 " auto create Session.vim file if none exists
let g:workspace_session_disable_on_args = 1 " Session will not load if launching with $ vim <file>
let g:workspace_autosave_untrailspaces = 1
let g:workspace_persist_undo_history = 0
let g:workspace_autosave = 0 " some find this unnecessary given linux's use of swap files, also
"  knock it for putting unecessary strain on system drives for the near constant stream of saves.
"  NOTE: To this point, however, it should be kept in mind that you might have swap files disabled
"  here in your .vimrc

"Add files you do not want autosaved and autotrimmed to the following array
let g:workspace_autosave_ignore = ['gitcommit']

let g:workspace_nocompatible = 0 " prevents plugin from overriding certain .vimrc settings. In my
"  case, it was overriding my `set noshowmode` setting to `set showmode`

let g:workspace_session_name = 'Session_neovim.vim'

"}}}

"}}}

endif

" }}}

" }}}

  "key rebindings "{{{
    "NOTE: VIM uses ASCII code to determine keypresses, so CTRL+n == CTRL+N, which means that
    "CTRL+SHFT is indistinguishable from CTRL. What's interesting though is that SHIFT can still be
    "used as a modifier key by itself
    "
    " cmap - command mode mapping
    " imap - insert mode mapping
    " map - normal, visual, and operator-pending mode mapping
    " map! - command and insert modes mapping
    " nmap - normal mode mapping
    " omap - operator-pending mode mapping
    " vmap - visual mode mapping
    " noremap - set mapping that is NOT recursive, works with various modes such as nnoremap (normal mode noremap), etc...
    "   What does that mean? If you have b = a, c = b, a recursive mapping would essentially be assigning c to a. However, if
    "   you specify that it should be noremap, that means that c will be set to b, without it cascading through to being a.
    " See :h map for details on how to map specific modes, etc

    "NOTE: How to set up vim to be able to use the ALT key as a modifier. Turns out this has to do
    "with discovering how the alt-key is interpretted by your terminal, then using that keycode type
    "thingy to modify its setting in vim. Here's how she goes:

    " $ sed -n l
    " Type whatever key combos you're interested in to see how they get sent to the terminal
      " NOTE: <C-c> to get out of the sed mode
    " Then use that 'keycode' in the following settings

    if !has ('nvim')
      execute "set <A-j>=\ej"
      execute "set <A-k>=\ek"
    endif

    " Increment/decrement operations
    " nnoremap + <C-a>
    " nnoremap - <C-x>

    "buffers  {{{
      set hidden " When closing an active buffer, rather than require a write or lose the data, the
      " buffer will instead still exist, but in a hidden state
      set confirm

    "switch buffers
      nnoremap <silent> [b :bprevious<CR>
      nnoremap <silent> ]b :bnext<CR>
      nnoremap <silent> [B :bfirst<CR>
      nnoremap <silent> ]B :blast<CR>

    "from Learn Vimscript the Hard Way
    " https://learnvimscriptthehardway.stevelosh.com/chapters/07.html
    :nnoremap <leader>ev :vsplit $MYVIMRC<cr>
    :nnoremap <leader>sv :source $MYVIMRC<cr>

    "}}}

    "profile performance {{{
    " NOTE: What's odd here is these <leader>u and <leader>o commands do not register most of the
    " time. I have no clue what might be causing this...
      " nnoremap <silent> <leader>u :profile start ~/profile.log \| :profile func * \| :profile file * <CR>
      " nnoremap <silent> <leader>o :profile pause \| :noautocmd qall! <CR>

      " nnoremap <silent> <leader>u :call ProfileStart()<CR>
      " nnoremap <silent> <leader>o :call ProfileEnd()<CR>

      " nnoremap <leader>u :call ProfileStart()
      " nnoremap <leader>o :call ProfileEnd()

      " function! ProfileStart()
      "   profile start ~/profile.log
      "   profile func *
      "   profile file *
      " endfunction

      " function! ProfileEnd()
      "   profile pause
      "   noautocmd qall!
      " endfunction

    "}}}

    "escape key {{{
    " NOTE: This is a 'dual-press', mashing these keys together at the same time
    " UPDATE: So I used this for a while and for the most part I really liked it. But I simply could
    " not STAND how I'd have to wait for the timeout to end whenever I end with a j or a k. So in it's
    " place, I'm going to try vim's default alternate keybind for <Esc> which is <C-[>
      " inoremap jk <Esc>
      " inoremap JK <Esc>
      " inoremap kj <Esc>
      " inoremap KJ <Esc>

    "}}}

    "cursor movement {{{
    " NOTE: I tried these for a bit, and while they were convenient from time to time, I regularly
    " reverted back to the vim defaults due to muscle memory. And I was constantly bothered by the
    " fact that J no longer joined lines
      " move by screen line instead of file line (useful for properly navigating lines when wordwrap
      " is enabled)

      " nnoremap j gj
      " nnoremap k gk

      " nnoremap H ^
      " nnoremap L $
        " NOTE: This replaces the default J command, which is for joining lines together. So remapped
        " that command to: nnoremap <leader>j J
      " nnoremap J <C-d>
      " nnoremap K <C-u>

    "}}}

    "disable arrow keys  {{{
    map      <Up>    <NOP>
    map      <Down>  <NOP>
    map      <Left>  <NOP>
    map      <Right> <NOP>
    inoremap <Up>    <NOP>
    inoremap <Down>  <NOP>
    inoremap <Left>  <NOP>
    inoremap <Right> <NOP>
    noremap  <Up>    <NOP>
    noremap  <Down>  <NOP>
    noremap  <Left>  <NOP>
    noremap  <Right> <NOP>
    imap     <Up>    <NOP>
    imap     <Down>  <NOP>
    imap     <Left>  <NOP>
    imap     <Right> <NOP>

    "}}}

    "leader and local leader  {{{
    " NOTE: Default key is \ . The reason I disabled , as the <leader> is because , and ; are default
    " keys for some repeat-like functions within vim
    " let mapleader         = ","
    " let g:mapleader       = ","
    " let maplocalleader    = ","
    " let g:maplocalleader  = ","

    " NOTE: Recommended by Primeagen, but it conflicts with my open/close folds being mapped to
    " <space>, introduces a delay of sorts before executing.
    " let mapleader         = " "
    " let g:mapleader       = " "
    " let maplocalleader    = " "
    " let g:maplocalleader  = " "
    "}}}

    "maximize current pane{{{
      " nnoremap <silent> <C-w>0 <C-W>_<C-W><Bar>

    "}}}

    " moving text lines with bubbling {{{
    nnoremap <A-j> :<C-u>move+<CR>==
    nnoremap <A-k> :<C-u>move-2<CR>==
    xnoremap <A-j> :move'>+<CR>gv=gv
    xnoremap <A-k> :move-2<CR>gv=gv

    "}}}

    "omni-complete keys {{{
      " :imap <TAB> <C-n>
      inoremap <C-p> <NOP>
        " NOTE: Disabling this default binding because I accidentally hit it all the time when
        " reaching for the <C-[> as a means to return to insert mode. Besides, I have already mapped
        " <Tab> for auto-complete purposes

    "}}}

    "open current file in browser  {{{
    " NOTE: disabled in favor of open-in-browser plugin
    " nmap <leader><leader><leader>b :!xdg-open %:p &<CR>
    " nnoremap gx :execute 'silient! !xdg-open "<cfile>" &> /dev/null &' <bar> redraw! <CR>

    "}}}

    "popup selection  {{{
      inoremap <expr> <C-k> pumvisible()?"\<Up>":"\<C-k>"
      inoremap <expr> <C-j> pumvisible()?"\<Down>":"\<C-j>"

    "}}}

    "show syntax highlight group for cursored word {{{
      nmap <leader>c :call <SID>SynStack()<CR>

      function! <SID>SynStack()
        if !exists("*synstack")
          return
        endif

        echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
      endfunction

      " NOTE: The below is another take on this, gives a bit more info
      " nmap <leader>c :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      "       \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      "       \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

    "}}}

    "switch windows  {{{
    " NOTE: Disabled in place of vim-tmux-navigator plugin
    " nnoremap <C-j> <C-w>j
    " nnoremap <C-k> <C-w>k
    " nnoremap <C-h> <C-w>h
    " nnoremap <C-l> <C-w>l

    "}}}

    "switch or create windows  {{{
    " NOTE: Disabled in place of vim-tmux-navigator plugin
    " nnoremap <C-j> :call WinMove('j')<cr>
    " nnoremap <C-k> :call WinMove('k')<cr>
    " nnoremap <C-h> :call WinMove('h')<cr>
    " nnoremap <C-l> :call WinMove('l')<cr>
    " function! WinMove(key)
    "   let t:curwin = winnr()
    "   exec "wincmd ".a:key
    "   if (t:curwin == winnr())
    "     if (match(a:key, '[jk]'))
    "       wincmd v
    "     else
    "       wincmd s
    "     endif
    "     exec "wincmd ".a:key
    "   endif
    " endfunction

    "}}}

    "tabs  {{{
    "NOTE: Okay... So after reading for a bit, it seems that tabs in vim are not intended to be the
    "same thing as tabs in other programs, like say a Web Browser. Tabs in vim are intended to be
    "used more as holding pins for different window layouts, rather than as separate places to view
    "files.

    "Instead, vim intends for buffers to be used. Evidently they're a lot more flexible and once
    "some familiarity is gained, can be *much* more powerful than using tabs.

    "switch tabs
    " map      <S-h> :tabp<CR>
    " map      <S-l> :tabn<CR>
    " nnoremap <S-h> :tabp<CR>
    " nnoremap <S-l> :tabn<CR>
    nnoremap <silent> [t :tabp<CR>
    nnoremap <silent> ]t :tabn<CR>

    "move tabs
    " NOTE: <S-i> is default for moving to the cursor to the start of the line... Will rethink if
    " I miss having this so readily available
    " :tabm <n> # where n is the tab index position you want it moved to, zero indexed
    " nmap <leader>t :tabmove

    " nmap     <S-u> :tabmove -1<CR>
    " nmap     <S-i> :tabmove +1<CR>
    " noremap  <S-u> :tabmove -1<CR>
    " noremap  <S-i> :tabmove +1<CR>

    "close current tab
    " nnoremap <S-w><S-w> :windo bd<CR>
    " nnoremap <C-w><C-w> :windo bd<CR>

    "}}}

    "yank from cursor to EOL  {{{
      nnoremap Y y$

    "}}}

  "}}}

  "color scheme schtuff {{{
  " NOTE: `h: xterm-colors` addresses some of what you talk about below

  " terminal color settings, so color schemes display properly {{{
  " NOTE: I've read some places that the ordering of the commands is important. This is why, for
  " example, the gruvbox settings are listed ABOVE the colorscheme declaration and why `set
  " termguicolors` is listed BELOW everything else.

  " NOTE: Sometimes manually setting the color fixes colorscheme issues.
  " UPDATE: From what I've read, this setting may conflict with `set termguicolors` below (ie only
  " have one active at a time)
  " set t_Co=256

  "Prevents the background color to resorting to black upon page scroll
  if &term =~ '256color'
    " Disable Background Color Erase
    set t_ut=
  endif

  " Throwing it in here again just as a precaution in case the if statement doesn't fire properly
  set t_ut=

  " UPDATE: Okay, so here's the low down so far... Trying to get tmux to play nice with vim's
  " colorscheme stuff. For whatever reason, the colors are a bit off whenever I launch vim inside
  " tmux. I've messed around with a lot of stuff. So far, here's what I've found. The only term
  " setting that consistently works is 'set termguicolors'. Whenever I try the others, like xterm or
  " xterm-256, the colors fail to load, even outside of tmux. I'll keep trying things here and there
  " but honestly, I've wasted enough time on this as it is and I'll come back to it later whenever
  " I have some more energy and have given myself a break from this mess.

  " It's my understanding that this should match what you have in .tmux.conf and/or displayed when you
  " `$ echo $TERM`
  " set term=xterm
  " set term=xterm-256color
  " set term=screen-256color
    " http://alturl.com/shy5e

  " Allow for a transparent background
  " NOTE: From what I can tell, this is not compatible with Lubuntu. In order to use something like
  " this, I suspect you'll have to use another desktop environment that supports transparency, like
  " gnome3 or ubuntu.
  " highlight Normal ctermbg=none
  " highlight NonText ctermbg=none

  " This is yet another way of addressing the improper rendering of colorthemes.
  " I'm not sure if it overrides the term256 stuff or what, but it works for some
  set termguicolors

  "}}}

  " scheme settings {{{
  "   NOTE: These settings need to be listed above the scheme selection so that they are in the proper
  "   load order when vim launches
  "   NOTE: If you want to directly edit a portion of the colorscheme, rather than edit the files
  "   directly, use the augroup MyColors at the bottom of this section. See included autocmd's for
  "   reference
  "   NOTE: After trying out some light colorschemes for a while, I discovered one crucial flaw in
  "   many of them, and that is that any git diff stuff is either devoid of ANY coloring for the
  "   statuses or it's so light and pale that it might as well be off. This likely because many of the
  "   light color schemes are prefer are stripped down to an almost monochromatic state. Perhaps there
  "   are light color schemes that still add diff colorings? Or, if push comes to shove and
  "   I **really** want to go back to light schemes, maybe I can create my own diff highlight settings
  "   as part of the LightschemeEdits auggroup? Another approach would be to simply switch to a dark
  "   colorscheme for diffing, which admittedly, wouldn't be the end of the world

    " Ayu {{{
    " let ayucolor="light"
    let ayucolor="mirage"
    " let ayucolor="dark"

    "}}}

    " Badwolf {{{
    " let g:badwolf_darkgutter = 1
    "let g:badwolf_html_link_underline = 0 " default 1

    "}}}

    "base16-grayscale-light {{{
    function! Base16GrayscaleLightEdits() abort
      hi Comment cterm=italic
    endfunction

    "}}}

    " colors-pencil {{{
    function! PencilEdits() abort
      " set background=light
      let g:pencil_higher_contrast_ui = 1
      let g:pencil_neutral_headings = 0
      let g:pencil_neutral_code_bg = 1
      let g:pencil_gutter_color = 0
      let g:pencil_spell_undercurl = 1
      let g:pencil_terminal_italics = 1

    endfunction

    "}}}

    " distilled {{{
    function! DistilledEdits() abort
      " hi Comment cterm=italic

      hi clear StatusLine
      hi clear StatusLineNC
      hi clear EndOfBuffer
      hi clear NonText

      hi StatusLine   ctermbg=0 ctermfg=8 cterm=NONE guibg=#213245 guifg=#6194ba gui=NONE
      hi StatusLineNC ctermbg=0 ctermfg=8 cterm=NONE guibg=#213245 guifg=#6194ba gui=NONE
      hi EndOfBuffer  ctermbg=0 ctermfg=8 cterm=NONE guibg=NONE    guifg=#6194ba gui=NONE
      hi NonText      ctermbg=0 ctermfg=8 cterm=NONE guibg=NONE    guifg=#6194ba gui=NONE

      hi clear Cursor
      hi clear Normal
      hi clear Title
      hi clear Visual
      hi clear Pmenu
      hi clear PmenuSbar
      hi clear ErrorMsg
      hi clear SignColumn

      " Change 'common' text color, original is #e4e4dd, default comment color is #6194ba
      " v1{{{
      " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#cacabc  guifg=NONE     gui=NONE
      " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#cacabc  gui=NONE
      " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#cacabc  gui=BOLDUNDERLINE
      " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#cacabc  gui=REVERSE
      " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#cacabc  guifg=#24364b  gui=NONE
      " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#cacabc  guifg=NONE     gui=NONE
      " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#cacabc  gui=NONE

      "}}}

      "v2 {{{
      " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#c1c1b1  guifg=NONE     gui=NONE
      " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#c1c1b1  gui=NONE
      " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#c1c1b1  gui=BOLDUNDERLINE
      " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#c1c1b1  gui=REVERSE
      " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#c1c1b1  guifg=#24364b  gui=NONE
      " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#c1c1b1  guifg=NONE     gui=NONE
      " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#c1c1b1  gui=NONE

      "}}}

      "v3 {{{
      " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#96b8d1  guifg=NONE     gui=NONE
      " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#96b8d1  gui=NONE
      " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#96b8d1  gui=BOLDUNDERLINE
      " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#96b8d1  gui=REVERSE
      " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#96b8d1  guifg=#24364b  gui=NONE
      " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#96b8d1  guifg=NONE     gui=NONE
      " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#96b8d1  gui=NONE

      "}}}

      "v4 {{{
      " hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#abc6da  guifg=NONE     gui=NONE
      " hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#abc6da  gui=NONE
      " hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#abc6da  gui=BOLDUNDERLINE
      " hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#abc6da  gui=REVERSE
      " hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#abc6da  guifg=#24364b  gui=NONE
      " hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#abc6da  guifg=NONE     gui=NONE
      " hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#abc6da  gui=NONE

      "}}}

      " ##ACTIVE##
      "v5 {{{
      hi Cursor           ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#99b2c4  guifg=NONE     gui=NONE
      hi Normal           ctermbg=0    ctermfg=7    cterm=NONE           guibg=#24364b  guifg=#99b2c4  gui=NONE
      hi Title            ctermbg=NONE ctermfg=7    cterm=BOLDUNDERLINE  guibg=NONE     guifg=#99b2c4  gui=BOLDUNDERLINE
      hi Visual           ctermbg=NONE ctermfg=7    cterm=REVERSE        guibg=NONE     guifg=#99b2c4  gui=REVERSE
      hi Pmenu            ctermbg=7    ctermfg=0    cterm=NONE           guibg=#99b2c4  guifg=#24364b  gui=NONE
      hi PmenuSbar        ctermbg=7    ctermfg=NONE cterm=NONE           guibg=#99b2c4  guifg=NONE     gui=NONE
      hi ErrorMsg         ctermbg=1    ctermfg=7    cterm=NONE           guibg=#e76d6d  guifg=#99b2c4  gui=NONE
      hi ColorColumn      ctermbg=8    ctermfg=7    cterm=NONE           guibg=#213245  guifg=#99b2c4  gui=NONE

      "}}}

    endfunction

    "}}}

    " eink {{{
    function! EinkEdits() abort
      set background=light
      set notermguicolors

      hi Comment cterm=italic

    endfunction

    "}}}

    "fogbell_light {{{
    function! FogbellLightEdits() abort
      set background=light
      set notermguicolors

      hi Comment cterm=italic

    endfunction

    "}}}

    "Greymatters {{{
    function! GreymattersEdits() abort
      hi Comment cterm=italic
    endfunction

    "}}}

    " gruvbit {{{
    function! GruvbitEdits() abort
      set background=light

      hi Comment cterm=italic

      " hi clear StatusLine
      " hi clear StatusLineNC

      " hi StatusLine   ctermbg=0 ctermfg=8 cterm=NONE guibg=#333333
      " hi StatusLineNC ctermbg=0 ctermfg=8 cterm=NONE guibg=#333333
    endfunction

    "}}}

    " gruvbox {{{
    let g:gruvbox_contrast_dark='soft'
    " let g:gruvbox_contrast_dark='medium'
    " let g:gruvbox_contrast_dark='hard'
    let g:gruvbox_italic = 1

    "}}}

    "gruvbox8_hard {{{
    function! Gruvbox8HardEdits() abort
      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif
    endfunction

    "}}}

    " gruvbox-material {{{
    function! GruvboxMaterialEdits() abort
      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      " let g:gruvbox_material_background = "soft"
      " let g:gruvbox_material_background = "medium"
      let g:gruvbox_material_background = "hard"

      let g:gruvbox_material_visual = 'grey background' " default
      " let g:gruvbox_material_visual = 'reverse'

      let g:gruvbox_material_palette = 'material' " default
      " let g:gruvbox_material_palette = 'mix'
      " let g:gruvbox_material_palette = 'original'

      let g:gruvbox_material_better_performance = 1

    endfunction

    "}}}

    " hybrid_x {{{
    function! HybridXEdits() abort
      let g:enable_bold_font = 0
      let g:enable_italic_font = 1
      let g:hybrid_transparent_background = 0

    endfunction

    "}}}

    " lightscheme edits {{{
    function! LightschemeEdits() abort
      set background=light

      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      hi Comment cterm=italic

    endfunction

    "}}}

    "meh {{{
    function! MehEdits() abort
      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      hi Comment cterm=italic

      hi clear StatusLine
      hi clear StatusLineNC

      hi StatusLine   ctermbg=0 ctermfg=8 cterm=NONE guibg=#333333
      hi StatusLineNC ctermbg=0 ctermfg=8 cterm=NONE guibg=#333333
    endfunction

    "}}}

    " monotone {{{
    function! MonotoneEdits() abort
      " let g:monotone_color = [120, 100, 70] " HSL array, affects the default font color
      " let g:monotone_secondary_hue_offset = 200 " offset secondary colors by x degrees from above monotone_color
      " let g:monotone_emphasize_comments = 1 " default 0, uses secondary color for comment font
      let g:monotone_contrast_factor = 0.92 " default 1.0

    endfunction

    "}}}

    " nord {{{
    function! NordEdits() abort
      let g:nord_bold = 0
      let g:nord_cursor_line_number_background = 1
      let g:nord_italic = 1
      let g:nord_italic_comments = 1
      let g:nord_underline = 1

      " Should help make fold and comment colorings more legible
      augroup Nord
        autocmd!
        autocmd ColorScheme nord highlight Comment guifg=#7b88a1 gui=bold
        autocmd ColorScheme nord highlight Folded guifg=#7b88a1
        autocmd ColorScheme nord highlight FoldColumn guifg=#7b88a1
      augroup end

    endfunction

    "}}}

    "oceanic-primal {{{
    function! OceanicPrimalEdits() abort
      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      hi Comment cterm=italic

    endfunction

    "}}}

    " onedark {{{
    function! OnedarkEdits() abort
      let g:onedark_hide_endofbuffer = 1 " default 0
      let g:onedark_terminal_italics = 1 " default 0

    endfunction

    "}}}

    " palenight {{{
    function! PalenightEdits() abort
      let g:palenight_terminal_italics = 1

    endfunction

    "}}}

    " paper {{{
    function! PaperEdits() abort
      set background=light

      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      hi Comment cterm=italic

    endfunction

    " }}}

    " parchment {{{
    function! ParchmentEdits() abort
      set background=light

      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      hi Comment cterm=italic

    endfunction

    "}}}

    "plain {{{
    function! PlainEdits() abort
      set background=light
      hi Comment cterm=italic

    endfunction

    "}}}

    "pyte {{{
    function! PyteEdits() abort
      set background=light
      hi Comment cterm=italic

    endfunction

    "}}}

    " seoul256 {{{
    function! Seoul256Edits() abort
      " Values range from 233[darkest] ~ 239[lightest]
      let g:seoul256_background = 233

    endfunction

    "}}}

    " sierra {{{
    function! SierraEdits() abort
      " Set darkness of background, enable only one
        let g:sierra_Sunset = 1
        " let g:sierra_Twilight = 1
        " let g:sierra_Midnight = 1
        " let g:sierra_Pitch = 1

    endfunction

    "}}}

    " solarized {{{
    function! SolarizedEdits() abort
      set background=light
      set notermguicolors

      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      let g:solarized_contrast="normal"
      let g:solarized_bold=0
      let g:solarized_italic=1

      hi Comment cterm=italic

    endfunction

    "}}}

    " solarized8 {{{
    function! Solarized8Edits() abort
      set background=light

      " disable bold font throughout
      if !has('gui_running')
          set t_Co=8 t_md=
      endif

      hi Comment cterm=italic

    endfunction

    "}}}

    " spacegray {{{
    function! SpaceGrayEdits() abort
      let g:spacegray_underline_search = 0
      let g:spacegray_use_italics = 1
      let g:spacegray_low_contrast = 0

    endfunction

    "}}}

    " substrata {{{
    function! SubstrataEdits() abort
      let g:substrata_italic_functions = 0

    endfunction

    "}}}

    " two-firewatch {{{
    function! TwoFirewatchEdits() abort
      set background=light

      hi Comment cterm=italic

    endfunction

    "}}}

    " vim-polar {{{
    function! VimPolarEdits() abort
      set background=light

      hi Comment cterm=italic

    endfunction

    "}}}

  augroup MyColors
    autocmd!
    autocmd Colorscheme base16-grayscale-light call LightschemeEdits()
    autocmd ColorScheme distilled call DistilledEdits()
    " autocmd ColorScheme distilled call LightschemeEdits()
    autocmd ColorScheme eink call EinkEdits()
    autocmd ColorScheme flattened_light call LightschemeEdits()
    autocmd ColorScheme fogbell_light call FogbellLightEdits()
    autocmd ColorScheme Greymatters call LightschemeEdits()
    " autocmd ColorScheme gruvbit call LightschemeEdits()
    " autocmd ColorScheme gruvbox8_hard call LightschemeEdits()
    " autocmd ColorScheme gruvbox-material call LightschemeEdits()
    autocmd ColorScheme meh call MehEdits()
    autocmd ColorScheme mountaineer-light call LightschemeEdits()
    autocmd ColorScheme oceanic-primal call OceanicPrimalEdits()
    autocmd ColorScheme Oldlace call LightschemeEdits()
    autocmd ColorScheme paper call LightschemeEdits()
    autocmd ColorScheme PaperColor call LightschemeEdits()
    autocmd ColorScheme pencil call PencilEdits()
    autocmd ColorScheme plain call LightschemeEdits()
    autocmd ColorScheme polar call LightschemeEdits()
    autocmd ColorScheme parchment call LightschemeEdits()
    autocmd ColorScheme pyte call LightschemeEdits()
    autocmd ColorScheme solarized call SolarizedEdits()
    autocmd ColorScheme solarized8 call LightschemeEdits()
    autocmd ColorScheme solarized8_flat call LightschemeEdits()
    autocmd ColorScheme solarized8_high call LightschemeEdits()
    autocmd ColorScheme solarized8_low call LightschemeEdits()
    autocmd ColorScheme spacegray call SpaceGrayEdits()
    autocmd ColorScheme two-firewatch call LightschemeEdits()
    autocmd ColorScheme typewriter call LightschemeEdits()
  augroup END

  "}}}

  " scheme selection {{{
  " NOTE: Lightline colorschemes are set in the lightline section

  set background=dark
  " Dark {{{
  " colorscheme alchemist
  " colorscheme anderson
  " colorscheme antares
  " colorscheme apprentice
  " colorscheme ayu
  " colorscheme base16-ashes
  " colorscheme base16-default-dark
  " colorscheme base16-grayscale-dark
  " colorscheme base16-gruvbox-dark-hard
  " colorscheme base16-gruvbox-dark-medium
  " colorscheme base16-tomorrow-night-eighties
  " colorscheme base16-twilight
  " colorscheme challenger_deep
  colorscheme distilled
  " colorscheme dogrun
  " colorscheme dracula
  " colorscheme fogbell_lite
  " colorscheme gruvbit
  " colorscheme gruvbox
  " colorscheme gruvbox8_hard
  " colorscheme gruvbox-material
  " colorscheme hybrid
  " colorscheme hybrid_material
  " colorscheme hybrid_reverse
  " colorscheme iceberg
  " colorscheme janah
  " colorscheme material
  " colorscheme meh
  " colorscheme menguless
  " colorscheme monotone
  " colorscheme moonfly
  " colorscheme mountaineer-grey
  " colorscheme nightfly
  " colorscheme nirvana
  " colorscheme nord
  " colorscheme OceanicNext
  " colorscheme off
  " colorscheme one
  " colorscheme onedark
  " colorscheme palenight
  " colorscheme plain
  " colorscheme quantum
  " colorscheme sierra
  " colorscheme slate
  " colorscheme slick
  " colorscheme solarized
  " colorscheme solarized8
  " colorscheme spacecamp
  " colorscheme spacegray
  " colorscheme spring-night
  " colorscheme substrata
  " colorscheme tempus_autumn
  " colorscheme tempus_classic
  " colorscheme tempus_dusk
  " colorscheme tempus_future
  " colorscheme tempus_night
  " colorscheme tempus_rift
  " colorscheme tempus_tempest
  " colorscheme tempus_winter
  " colorscheme tender
  " colorscheme two-firewatch
  " colorscheme vim-monokai-tasty
  "colorscheme wal
  "colorscheme wpgtk
  " colorscheme yami

  "}}}

  " set background=light
  " Light {{{
  " colorscheme ayu
  " colorscheme base16-grayscale-light
  " colorscheme blueshift
  " colorscheme editplus
  " colorscheme eink
  " colorscheme flattened_light
  " colorscheme fogbell_light
  " colorscheme Greymatters
  " colorscheme gruvbox-material
  " colorscheme mountaineer-light
  " colorscheme nofrils-light
  " colorscheme nofrils-sepia
  " colorscheme off
  " colorscheme Oldlace
  " colorscheme pencil
  " colorscheme paper
  " colorscheme parchment
  " colorscheme plain
  " colorscheme polar
  " colorscheme pyte
  " colorscheme PaperColor
  " colorscheme solarized
  " colorscheme solarized8
  " colorscheme solarized8_high
  " colorscheme solarized8_low
  " colorscheme two-firewatch
  " colorscheme typewriter
  " colorscheme xcode
  " colorscheme yang

  " The 'Nope, not feeling it'-ers
  " colorscheme 256-grayvim
  " colorscheme archery
  " colorscheme base16-default-dark
  " colorscheme Base2Tone_DesertDark
  " colorscheme Base2Tone_EarthDark
  " colorscheme Base2Tone_EveningDark
  " colorscheme Base2Tone_ForestDark
  " colorscheme falcon
  " colorscheme grb256
  " colorscheme happy_hacking
  " colorscheme lucius
  " colorscheme minimalist
  " colorscheme molokai
  " colorscheme monochrome
  " colorscheme monotone-terminal
  " colorscheme nofrils-dark
  " colorscheme oldbook
  " colorscheme sacredforest
  " colorscheme seoul256
  " colorscheme summerfruit256
  " colorscheme vividchalk
  " colorscheme zenburn

  "}}}

  "}}}

  "}}}

  "miscellaneous schtuff {{{
  filetype plugin indent on
  syntax on
  set re=1 " forces vim to revert to an older regex engine, which may be faster for syntax
    " highlighting for ruby files
  let g:ruby_path='' " evidently, setting this to ANY value will likely give speed benefits
  let ruby_no_expensive=1
  " set visualbell
  set autoread " automatically reload files changed outside vim
  set backspace=indent,eol,start
  " set cursorcolumn " highlight current column
  " set cursorline " highlight current line
  set diffopt+=vertical " When comparing files, arrange side by side vertically
  set history=1000

  set lazyredraw " redraw screen only when needed, can speed up macros
  set ttimeoutlen=10 " make key sequences register faster, default 100
  set ttyfast " indicates a fast terminal connection, may improve latency responses

  set linespace=0
  set matchtime=1 " highlight match for 0.x seconds
  set modifiable " allows a buffer to be modified
  set nojoinspaces " Use one space, not two, after punctuation
  set nostartofline " keeps cursor in current column when changing rows

  " set number " enable line numbers
  " set relativenumber " enable relative line numbers, see :h relativenumber for more info

  " NOTE: The below toggles relative numbering
  " set number relativenumber
  "   function! ToggleRelativeOn()
  "     set rnu!
  "     set nu
  "   endfunction

  "   augroup RelativeNumber
  "     autocmd!
  "     " autocmd FocusLost * call ToggleRelativeOn()
  "     " autocmd FocusGained * call ToggleRelativeOn()
  "     " autocmd InsertEnter * call ToggleRelativeOn()
  "     " autocmd InsertLeave * call ToggleRelativeOn()

  "     autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  "     autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
  "   augroup END

  " set foldcolumn=3
    " NOTE: acts as a left side margin/padding, very cool!

  set path=$PWD/** " set find path to current working directory
  " set path+=**
  "   NOTE: This can be an interesting alternative if you ever want to toy around with vim's built-in
  "   fuzzy file finding capabilities. Got the idea from this video:
  "     https://youtu.be/XA2WjJbmmoM?t=380 near the 6:20 mark
  set ruler " Show cursor position at all times
  set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
  set showcmd " shows command line inputs at the bottom right of screen
  set showmatch " show matching brackets
  "   NOTE: In practice, I found this often introduced considerable lag while scrolling. To disable
  "   entirely, enable the following:
    " set noshowmatch " do NOT show matching brackets
    " let g:loaded_matchparen=1
  set title " use filename in window title
  if !has ('nvim')
    set viminfo=%,<800,'100,/50,:100,h,f1,n~/dotfiles/vim/.viminfo
      " https://stackoverflow.com/a/23036077
  endif
  set wildmenu " visual autocomplete menu
  " NOTE: wildmode *only* pertains to command-line completion suggestions within vim. So whenever you
  " type `:colo <TAB>`, the way it autocompletes the word to be `:colorscheme`, that completion login
  " is what is being configured here. Default: full
  " set wildmode=longest:full,full
  set wildmode=list:longest,list:full
  " set wildmode=list:longest,full
  " set wildmode=longest,list,full
  set wildignore=*.o,*.obj,*.bak,*.exe

  set nrformats= " treat all numbers, even those with leading zeroes, as decimals. By default, vim
  " treats numbers with leading zeroes as octal digits
  "
  " set nrformats+=alpha " adds alphabet chars to the increment/decrement operations, so you're able
  "   to use use ^A and ^X for letters as well as numbers.
  "   UPDATE: In practice, the problem with this is that it will 'fire' on whatever letter your cursor
  "   is on, even though you may intend for it to modify the nearest number following your cursor
  "   position. So for this reason, I've left it off

  " Fix issues with the enter key mapping when in a quickfix window
  augroup QuickfixEnter
    autocmd!
    autocmd CmdwinEnter * nnoremap <CR> <CR>
    autocmd BufReadPost quickfix nnoremap <CR> <CR>
  augroup END

  "Allow stylesheets to autocomplete hyphenated words
  augroup AutocompleteHyphenatedWords
    autocmd!
    autocmd FileType css,scss,sass,less setlocal iskeyword+=-
  augroup END

  " Treat hyphenated words as a word
  set iskeyword+=-

  " https://stackoverflow.com/questions/57367212/ctags-unable-to-find-variables-that-contain-hyphen
  " function! CWordWithKey(key) abort
  "   let s:saved_iskeyword = &iskeyword
  "   let s:saved_updatetime = &updatetime
  "   if &updatetime > 200 | let &updatetime = 200 | endif
  "   augroup CWordWithKeyAuGroup
  "     autocmd CursorHold,CursorHoldI <buffer>
  "               \ let &updatetime = s:saved_updatetime |
  "               \ let &iskeyword = s:saved_iskeyword |
  "               \ autocmd! CWordWithKeyAuGroup
  "   augroup END
  "   execute 'set iskeyword+='.a:key
  "   return expand('<cword>')
  " endfunction
  " autocmd FileType make setlocal iskeyword+=45
  " nnoremap <buffer> <silent> <c-]> :execute 'tag '.CWordWithKey(45)<CR>

  " automatically resize panes with <C-w>= when vim window is resized
  " autocmd VimResized * wincmd =
  " set equalalways

  " enable jump between do/end Ruby blocks
  " runtime macros/matchit.vim

  " fix corrupt symbols
  let &t_TI = ""
  let &t_TE = ""

  " Trying to make it so that vim-commentary will use " for comments rather than #
  " https://vim.fandom.com/wiki/Comment_lines_in_different_filetypes
  " function CommentIt ()
  "   if &filetype == "vim"
  "     vmap +# :s/^/"/<CR>
  "     vmap -# :s/^"//<CR>
  "   endif
  " endfunction
  "
  " autocmd BufEnter * call CommentIt ()

  " Indents list structures properly when bulleted with - or *. It also does some other things, but
  " I'm not sure about those...
  "   https://superuser.com/questions/131950/indentation-for-plain-text-bulleted-lists-in-vim
  "   :h comments
  "   :h format-comments
  set comments =s1:/*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-,fb:[+],fb:[x],fb:[*],fb:[-]
  set comments +=fb:*
  set comments +=fb:-

  " ToggleZoom() and RetainZoomStatus() are handy for moving vim instance tiles around in dwm
  function! ToggleZoom()
      let g:zoom_status = get(g:, 'zoom_status', 0)
      if g:zoom_status == 0
          " Not currently zoomed, so lets zoom in
          wincmd _
          wincmd |
          let g:zoom_status = 1
      else
          " Currently zoomed in, so lets zoom out
          wincmd =
          let g:zoom_status = 0
      endif
  endfunction

  function! RetainZoomStatus()
      " Assume that if we haven't called ToggleZoom() before then all windows
      " are probably meant to be equal (set g:zoom_status to 0)
      let g:zoom_status = get(g:, 'zoom_status', 0)
      if g:zoom_status == 0
          wincmd =
      else
          wincmd _
          wincmd |
      endif
  endfunction

  augroup zoom
      autocmd!
      autocmd VimResized * call RetainZoomStatus()
  augroup END

  " nnoremap <leader>0 :call ToggleZoom()<CR>
  nnoremap <silent><C-w>0 :call ToggleZoom()<CR>

  set noerrorbells vb t_vb=
  if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
  endif

  " Always move by visual line, useful when navigating wrapped lines
  noremap <silent> k gk
  noremap <silent> j gj
  noremap <silent> 0 g0
  noremap <silent> $ g$

  " from ThePrimeagen
  " https://www.youtube.com/watch?v=hSHATqh8svM
  " yanking
  nnoremap Y y$
  " keep cursor centered
  nnoremap n nzzzv
  nnoremap N Nzzzv
  nnoremap J mzJ`z
  nnoremap { {zz
  nnoremap } }zz
  " nnoremap ]c ]czz
  " nnoremap [c [czz
  "   NOTE: Seems to conflict with moving through gitgutter chunks

  " undo break points
  inoremap , ,<c-g>u
  inoremap . .<c-g>u
  inoremap ! !<c-g>u
  inoremap ? ?<c-g>u
  inoremap [ [<c-g>u
  inoremap ] ]<c-g>u
  " moving text
  "   NOTE: Cool, may use later, but right now these conflict with other keymappings
  " vnoremap J :m '>+1<CR>gv=gv
  " vnoremap K :m '<-2<CR>gv=gv
  " inoremap <C-j> <esc>:m .+1<CR>==
  " inoremap <C-k> <esc>:m .-2<CR>==
  " nnoremap <leader>j :m .+1<CR>==
  " nnoremap <leader>k :m .-2<CR>==

  " abbreviations {{{

  " }}}

  "clipboard integration {{{
  " So this is a tricky one... vim uses its own clipboard (aka register) it calls 'unnamed' which is
  " wholly separate from that used by the OS. Which means the standard CTRL+C and CTRL-V stuff won't
  " work when trying to take something out of vim. Here's what I understand about it so far... (more
  " info at `:help clipboard`)
  "
  " In order to get things to transfer, you have to direct vim to record the stuff into a different
  " register. In order to get things to transfer, you have to direct vim to record the stuff into
  " a different register. Linux has two registers it can use, <quote>* and <quote>+  From what I can
  " tell, <quote>+ seems to be the usual go-to. To use this, say you want to yank a line from vim and
  " paste it into a separate program, you'd type <quote>+yy. This copies into the system clipboard and
  " from there you should be able to paste it as normal wherever you want.
  "
  " Now... There are some caveats to this.
  "   1) You need to be on a version of vim that supports +clipboard. If you followed your own cooking
  "      in this regard as noted in your .reference file, you should be good to go here.
  "   2) You may have to use the * register instead of the + register.
  "   3) I'm including here in the .vimrc a few other settings immediately below that some users say
  "      has helped get the functionality to take. These shouldn't conflict with the <quote>+
  "      approach, but I'll throw'em in here to give them a whirl.

  " NOTE: Settings interfering w neocomplete and causing funky things to happen with the word-wrap
  "   settings, so disabled
  " set paste " helps maintain the formatting of pasted text into vim
  " set clipboard+=unnamed " use the clipboard of vim by default
  " set go+=a " visual selection automatically copied to the clipboard
  "
  " Separate from the abovementioned stuff, the below is to better integrate copying and pasting with
  "   the system clipboard.
  " vnoremap <C-c> "*y
  " map <silent><leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr>"
  " map <silent><leader><S-p> :set paste<CR>O<esc>"*]p:set nopaste<cr>"

  inoremap <C-r> <C-r><C-o>
    " NOTE: When pasting content while in Insert mode with <C-r>, vim may treat the pasted text as
    " though it is literally typed, which can be a security concern. I say 'may treat' because from
    " what I've read, it sounds like this may have been fixed in some Vim 8.xxx version. This config
    " insures that the text is inserted literally, just like Normal mode (which is 'safe' by the way,
    " so if in doubt, just paste with Normal mode).

  " }}}

  "ctags {{{
  " NOTE: I'm not entirely sure ctags will do its magic for ruby/rails and/or javascript. See the
  "   ctags section up in plugins for more info
  " set tags=./tags,tags;$HOME
  " command! MakeTags !ctags -R .
  " NOTE: https://youtu.be/XA2WjJbmmoM?t=981 (@ 16:21)
  " <C-]>   jump to tag under cursor
  " g <C-]> for ambiguous tags
  " <C-t>   jump back to tag stack

  "}}}

  "cursor shapes changing based on vim mode {{{
  " tmux
  " if exists('$ITERM_PROFILE')
  "   if exists('$TMUX')
  "     let &t_SI = "\<Esc>[5 q"
  "     let &t_EI = "\<Esc>[0 q"
  "   else
  "     let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  "     let &t_SR = "\<Esc>]50;CursorShape=2\x7"
  "     let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  "   endif
  " end

  " xfce-terminal
  "   NOTE: This works, but I find it's inconsistent at times, will display the cursor in insert mode
  "   even after I've long since returned to normal mode.
  " if has("autocmd")
  "   au InsertEnter * silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_BLOCK/TERMINAL_CURSOR_SHAPE_UNDERLINE/' ~/.config/xfce4/terminal/terminalrc"
  "   au InsertLeave * silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_UNDERLINE/TERMINAL_CURSOR_SHAPE_BLOCK/' ~/.config/xfce4/terminal/terminalrc"
  "   au VimLeave * silent execute "!sed -i.bak -e 's/TERMINAL_CURSOR_SHAPE_UNDERLINE/TERMINAL_CURSOR_SHAPE_BLOCK/' ~/.config/xfce4/terminal/terminalrc"
  " endif

  "}}}

  "folding {{{
  set foldenable
  " set foldlevelstart=99
  " set foldnestmax=10 " 10 nested folds max

  " NOTE: Enable only one of the below methods at a time
  " set foldmethod=manual
  " set foldmethod=indent
  " set foldmethod=expr " fold per REGEX
  set foldmethod=marker " persistent folds based on saved marker positions
  " set foldmethod=syntax
  " set foldmethod=diff " recommended to never set it this way manually. You
                        " can enter this fold mode by going into vim diff mode

  " NOTE: Uncomment the below to remember fold settings
  " augroup RememberFolds " remember fold settings
  "   autocmd!
  "   autocmd BufWinLeave ?* mkview
  "   autocmd BufWinEnter ?* silent loadview
  " augroup END

  "Sets Space as the key to open/close folds as long as cursor is on a fold
  nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
  vnoremap <Space> zf

  "}}}

  "git {{{
  au FileType gitcommit setlocal tw=72
    " NOTE: If for some reason this doesn't work, be sure you also have the following enabled:
    "   filetype indent plugin on

  "}}}

  "remove trailing spaces on save and preserve cursor position{{{
  " https://stackoverflow.com/a/1618401
  fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
  endfun

  augroup StripTrailingWhiteSpaces
    autocmd!
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
  augroup END
  " NOTE: If you want this to apply only to certain filetypes, you can modify this last line to
  "   replace the * as follows: autocmd FileType c,cpp,java, ... etc

  "}}}

  "search ------------------"{{{
  set hlsearch " highlight searches
  set incsearch " search as characters are entered
  set ignorecase " makes search results case-insensitive
  set smartcase " capitalized searches search for capital occurence, lower-case is case insensitive
  nnoremap <silent><leader>. :noh<CR>
  " NOTE: turn off highlighted search results after leaving search mode
  set gdefault " searches default to global, that way you don't always have to suffix it with /g
  vnoremap // y/\V<C-R>"<CR>
  " NOTE: This allows you to search any visually selected text with by pressing `//`.
  " https://vim.fandom.com/wiki/Search_for_visually_selected_text
  set shortmess-=S " displays search index

  "}}}

  "spelling ----------------"{{{
  set nospell
  " :setlocal spell spelllang=en_us " will highlight mispelled words in local buffer
  " :set spell # enable spell checking for current file
        " ]s [s       # move between misspelled words
        " ]S [S       # move between bad words, not at rare words or words for another region
        " z=          # see suggestions
        " zg          # add visually selected word to vim's dictionary
        " zug         # remove visually selected word from vim's dictionary
        " zw          # mark word as misspelled
        " <C-p> <C-n> # highlighting and auto completion
  " :set nospell # disable spellchecking
  "
  " If you want to set it up so that spell check is loaded on startup, uncomment the following:
  "   NOTE: You still have to enable spellcheck mode with `:set spell`
  " :set spell spelllang=en_us

  " The vim help files recommend NOT using the vim-spell plugin, but instead use what's already built
  " into vim. The following comment disables the vim-spell plugin
  let loaded_spellfile_plugin = 1

  " Troubleshooting
    " If you're receiving a message about vim not being able to download the appropriate spell files,
    " download them from here and put them in ~/.vim/spell
    " ftp://ftp.vim.org/pub/vim/runtime/spell/

  "}}}

  "splitpanes --------------"{{{
  set splitright " horizontal split opens new pane right of current pane
  set splitbelow " vertical split opens new pane below of current pane

  "}}}

  "statusline --------------{{{
  " http://tdaly.co.uk/projects/vim-statusline-generator/

  set laststatus=2 " 0:never, 1:2+windows, 2:always

  " set statusline=
  " set statusline+=%<%f
  " set statusline+=%h%m%r
  " set statusline+=%=%-14 %P
  " set statusline+=%{StatuslineMode()}

  " set statusline+=%{gitbranch#name()}
  " set statusline+=%f
  " set statusline+=%=
  "   NOTE: Looks like this may be what switches to the right side
  " set statusline+=%y
  " set statusline+=%P
  " set statusline+=%l
  " set statusline+=%c

  " function! StatuslineMode()
  "   let l:mode=mode()
  "   if l:mode==#"n"
  "     return "NORMAL"
  "   elseif l:mode==?"v"
  "     return "VISUAL"
  "   elseif l:mode==#"i"
  "     return "INSERT"
  "   elseif l:mode==#"R"
  "     return "REPLACE"
  "   elseif l:mode==?"s"
  "     return "SELECT"
  "   elseif l:mode==#"t"
  "     return "TERMINAL"
  "   elseif l:mode==#"c"
  "     return "COMMAND"
  "   elseif l:mode==#"!"
  "     return "SHELL"
  "   endif
  " endfunction

  " set statusline+=%F " display active file's relative path in statusline, <C-g> is manual command
  " set statusline+=%{gutentags#statusline()}
  " set statusline+=%{noscrollbar#statusline(20,'-','#')}

  " let &statusline.='%{abs(line(".") - line("v")) +1}'
    " NOTE: This displays visual selection counts on the right side of the statusline. For some
    " reason though, I seem to already have them, even without this enabled.

  set noshowmode " do not display vim mode in the status line
  set report=0 " threshold for reporting line changes. For example, set to zero to display for
  " single line yanks
  "
  " set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
  "                | | | | |  |   |      |  |     |    |
  "                | | | | |  |   |      |  |     |    +-- current column
  "                | | | | |  |   |      |  |     +-- current line
  "                | | | | |  |   |      |  +-- current % into file
  "                | | | | |  |   |      +-- current syntax
  "                | | | | |  |   +-- current fileformat
  "                | | | | |  +-- number of lines
  "                | | | | +-- preview flag in square brackets
  "                | | | +-- help flag in square brackets
  "                | | +-- readonly flag in square brackets
  "                | +-- modified flag in square brackets
  "                +-- full path to file in the buffer

  "}}}

  "swapfile and related  {{{
  " NOTE: The default setting is
    set backup " standard backup file
    set writebackup " backupfile created while editing a file
    set swapfile

  " NOTE: You disabled swapfiles at some point because you repeatedly ran into merge issues when
  " switching between laptop and VM. However, you read something recently that seemed to indicate
  " that swap files are a GOOD thing for vim and that some features depend on their being
  " enabled. Further, when it came to git repo issues, may advised simply adding the swap related
  " files to .gitignore.
  "   *.sw?
  "   *~
  " If you would like to go back to a swap file-less setup, simply comment out the above and use the
  " following:
    " set nobackup
    " set nowritebackup
    " set noswapfile

  " NOTE: the various updateX settings mostly come into play if swapfiles are enabled, but there are
  " some plugins that tap into its setting, for example gitgutter uses it to determine how quickly it
  " should show the git symbols after a change. It also affects how quickly vim-workspace autosaves on
  " inactivity if that's something you have enabled.
  set updatetime=200 " default 4000 milliseconds (ie 4 secs)
  set updatecount=200 " default 200, autosave after typing this many characters
  "
  "move swp files so they don't affect repos
  " if isdirectory($HOME . '/.vim/swap') == 0
  "   :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
  " endif
  " set directory=./.vim-swap//
  " set directory+=~/.vim/swap//
  " set directory+=~/tmp//
  " set directory+=.

  " https://coderwall.com/p/sdhfug/vim-swap-backup-and-undo-files
  " In order for this to work, you must manually create the following dirs:
  "   $ mkdir ~/.vim/.backup ~/.vim/.swap ~/.vim/.undo
  " set undodir=~/.vim/.undo//
  " set backupdir=~/.vim/.backup//
  " set directory=~/.vim/.swap//

  "}}}

  "page scrolling ----------"{{{
  " NOTE: In practice, I find these definitions misleading. If anything, they're swapped. The window
  " will move once the scrolloff is hit and the window will advance/recede an additional number of
  " lines per scrolljump
  set scrolloff=8 " minimum number of lines to keep above/below cursor
  set scrolljump=8 " number of lines to scroll when triggered

  "}}}

  "tabs, indentation, and word wrapping  "{{{
    " UPDATE: So I'm currently rocking a modified tabstop value... After reading the vim/wiki pages
    " though, it sounds like this may be partly what's responsible for the text spacing/indents
    " looking weird after I copy and paste something from vim. So if you find yourself running into
    " that situation often, give this another read to see what changes you may need to try out below:
    " https://www.reddit.com/r/vim/wiki/vimrctips#wiki_think_twice_before_changing_tabstop
  set showtabline=1 " 0:never, 1:2+tabs, 2:always
  " set nowrap " disable word wrapping.
  "   NOTE: Word wrapping is the dynamic resizing of widths to fit the given window size, not the
  "   same thing as setting a textwidth. It does not enter 'hard' line breaks, just 'soft' line
  "   breaks.
  set wrapmargin=0
  set textwidth=100 " set max line width.
    " NOTE: the colorcolumn settings is subtracted/added from this number
  set colorcolumn=+1 " sets a reference line at textwidth + colorcolumn
  set tabstop=2 " number of tab spaces
  set expandtab " convert tabs to the matching number of spaces
  set shiftwidth=2
  set softtabstop=2
  set shiftround
  " set formatoptions=tcq " default
  " NOTE: see :h fo-table
  " NOTE: rather than set an entirely new formatoptions string, the manual advises to += or -=
  " changes. This sounds good in practice, but how would this play out if/when a plugin modifies the
  " formatoptions string directly?
  " set formatoptions-=t formatoptions+=croql
  " set formatoptions=qrn1
  " set formatoptions=2jtcq
  " set formatoptions=tcqrn1
  " set formatoptions=ctnqro " used by vimwiki
  set formatoptions=tcrqn1jp

  " NOTE: So judging from the :h, the indent stuff is very intricate with vim. Some of the settings
  " overwrite or invalidate other indent settings
  set autoindent
  " set smartindent " to use, must also enable autoindent
    " NOTE: vimrctips recommends NEVER using smartindent. Evidently it's an old script that isn't so
    " smart anymore...
  set copyindent " copy previous indentation on autoindent, overwrites smartindent if both are enabled.
  set breakindent " for wrapped lines, preserves indent according to 'parent' line
  "
  set smarttab " at start of line, <tab> inserts shiftwidth spaces, <Bs> deletes shiftwidth spaces
  set showbreak=....
  set nomodeline " do NOT use modeline (security), always use nomodeline

  "}}}

  "tab completion ----------"{{{
  "insert tab if beg of line, else as completion
  function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col-1] !~ '\k'
      return "\<tab>"
    else
      return "\<C-p>"
    endif
  endfunction
  " inoremap <Tab> <C-r>=InsertTabWrapper()<cr>
  " inoremap <S-Tab> <C-n>

  "}}}

  "todo syntax highlighting list  {{{
  "NOTE: See :h :syn-keyword

  if has('autocmd') && v:version > 701
    augroup Todo
      autocmd!
      autocmd Syntax * call matchadd(
        \ 'Todo',
        \ '\v\W\zs<(NOTE|INFO|IDEA|TODO|FIXME|CHANGED|BUG|HACK|REVIEW|TEMP|QUESTION|ANSWER|UPDATE)>'
        \)
    augroup END
  endif

  "}}}

  "visual whitespace -------"{{{
  "set listchars=tab:»·,trail:·,nbsp:·
  " set listchars=tab:>-,trail:·,nbsp:_,extends:+,precedes:+
  set listchars=tab:»·,trail:·,nbsp:_,extends:+,precedes:+
  "set listchars+=tab:\|\ " show indent lines
  set list

  "}}}

  "verbose  {{{
  "   NOTE: For some reason, complains either of these settings are invalid...
  " set verbosefile = ~/.vim/vim_verbose_output.log
  " set verbosefile = vim_verbose_output.log

  "}}}

  "vimdiff {{{
  " NOTE: This makes it so that when you run `git difftool` on file/s, they will not open in git's
  " default readonly mode
  " UPDATE: The same thing is probably accomplished through the customized difftool command you've set
  " up in gitconfig, since it does NOT use the -R option (ie the default option that git uses to set
  " the files as readonly)
  " UPDATE2: Okay so here's a new tidbit... It turns out that by default, the difftool works with
  " temporary files, not the 'live' files themselves, which means any saves you make don't actually do
  " anything... Still trying to find out if there's a way around that because it seems like that would
  " be a good feature to have.

    " if &diff
    "   set noreadonly
    " endif

  "}}}

  "}}}

