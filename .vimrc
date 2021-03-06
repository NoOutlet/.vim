"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable filetype plugins
filetype plugin indent on

" Use spaces instead of tabs
set noexpandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" display tabs as periods and trailing whitespace as dot
set list
set listchars=tab:.\ ,trail:·

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

:autocmd Filetype ruby set softtabstop=2
:autocmd Filetype ruby set expandtab
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use ack for searching
set grepprg=ack\ -a

" Always show current position
set ruler

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Show numbers on left
set number

" Show relative number lines
" set relativenumber

" Backspace deletes carriage returns
set backspace=2

" Toggle Paste mode with <F2>
set pastetoggle=<F2>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Use Pathogen
execute pathogen#infect()

" Recognize syntax?
syntax on

" Set to auto read when a file is changed from the outside
set autoread

" Set color in an ignored file so different systems can have different schemes
:so ${HOME}/.vim/.vimcolor

" Toggle NERDTree with <Ctrl+n>
map <C-n> :NERDTreeToggle<CR>

" Quit NERDTree when opening a file
let NERDTreeQuitOnOpen=1

" Open NERDTree if not editing specific file
autocmd vimenter * if !argc() | NERDTree | endif

" Map Ctrl+J and Ctrl+K to next/prev item in location list
map <C-J> :lnext<CR>
imap <C-J> <ESC>:lnext<CR>i
map <C-K> :lprev<CR>
imap <C-K> <ESC>:lprev<CR>i
nnoremap <CR> :noh<CR><CR>

" Let vim-airline take care of showing the mode
set noshowmode
" Try showing airline symbols
let g:airline_powerline_fonts = 1

" Setup Linting
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
