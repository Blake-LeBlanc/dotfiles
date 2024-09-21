  vim.cmd [[
    let g:startify_files_number           = 5
    let g:startify_session_persistence    = 1

    let g:startify_fortune_box_max_width = 50
      " NOTE: This does not seem to do anything. Perhaps it requires wrap do be enabled within vim?
    " Get rid of quote cow
    " let g:startify_custom_header = 'startify#fortune#quote()'
    " let g:startify_custom_header = 'startify#pad(startify#fortune#quote())'
    " let g:startify_custom_header = 'startify#center(startify#fortune#quote())'
    " let g:startify_custom_header = 'startify#fortune#boxed_quote()'
    " let g:startify_custom_header = ['startify']
    let g:startify_custom_header = ''
    let g:startify_padding_left = 5 " default 3

    " Simplify the startify list to just recent files and sessions
    let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

    " let g:startify_session_dir = '~/.vim/session' " default vim
    " let g:startify_session_dir = '~/.local/share/nvim/session' " default nvim
    let g:startify_session_dir = '~/.config/nvim/sessions'

  ]]

