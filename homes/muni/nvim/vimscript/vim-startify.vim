let g:startify_custom_header = startify#fortune#cowsay('', '═','║','╔','╗','╝','╚')
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']             },
    \ { 'type': 'dir',       'header': ['   Recent in '. getcwd()] },
    \ { 'type': 'files',     'header': ['   Recent']               },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']            },
    \ { 'type': 'commands',  'header': ['   Commands']             },
    \ ]
let g:startify_session_persistence = 1
