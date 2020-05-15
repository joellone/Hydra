"set color scheme
color desert
"set line number
set nu
"set tab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set cindent
set expandtab
set ruler

syntax enable
syntax on
set autoindent

"set font
set guifont=Cascadia\ Mono\ 11

"set taglist
""set tags=tags
""let Tlist_Show_One_File=1
""let Tlist_Exit_OnlyWindow=1
""let Tlist_Process_File_Always=1
""let Tlist_Auto_Open=1

"set omnicppcomplete
set nocp

let g:Tlist_Ctags_Cmd='/usr/bin/ctags'

filetype on

highlight Pmenu    guibg=darkgrey  guifg=black
highlight PmenuSel guibg=lightgrey guifg=black

execute pathogen#infect()

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_verilog_checkers = ['iverilog']
let g:syntastic_verilog_systemverilog_checkers = ['iverilog']
let g:syntastic_vhdl_checkers = ['vcom']
