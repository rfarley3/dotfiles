colorscheme zenburn
" show line number
set number
" show partial commands as you type them
set sc
" use visual bell
set vb
" turn off error bells
set noeb
" show ruler, col at bottom
set ruler
" show partial search matches as you type search
set incsearch
" highlight the search match
set hlsearch
" use syntax highlighting
syntax on
" we use vim as a pager, so within vim it needs to know to not call itself
let $PAGER=''
" enable click to move the cursor and highlight text
set mouse=a
" yank/paste from system keyboard (may be Mac specific), must have +clipboard build option
set clipboard=unnamed
" autoindent
set ai
" ?? set smartindent (a less strict cindent)
" use spaces for tabs in py files
" but default to tabs for others (c, cpp, h, etc)
au BufRead,BufNewFile *.py set expandtab
" use c indention std for c files, ai for others
au BufRead,BufNewFile *.c set cindent
au BufRead,BufNewFile *.cpp set cindent
au BufRead,BufNewFile *.h set cindent
" how many chars wide to use (visually) for a tab
set tabstop=4
" an indent equals this many spaces, used if expandtab is on
set shiftwidth=4
" how many chars wide to use for a tab, if expandtab is on, then all spaces, if off, then mix of tab and space
set softtabstop=4
" allows backspace to cross newlines, consume indents in one press, etc
set backspace=indent,eol,start
" some macros for common tedious to type sequences
ab #b /****************************************
ab #e ^V^H*****************************************/
" Block comment/uncomment; Select with shift+v
" # to comment your lines from the first column.
" vnoremap <silent> # :s/^/#/<cr>:noh<cr>
" -# to uncomment the same way.
" vnoremap <silent> -# :s/^#//<cr>:noh<cr>
" Set off the other paren
" seems to be default
"highlight MatchParen ctermbg=4
" }}}
" Tab navigation kinda like Firefox.
nnoremap <C-p>   :tabprevious<CR>
inoremap <C-p>   <Esc>:tabprevious<CR>i
nnoremap <C-n>   :tabnext<CR>
inoremap <C-n>   <Esc>:tabnext<CR>i
nnoremap <C-t>   :tabnew <bar> :E<CR>
inoremap <C-t>   <Esc>:tabnew <bar> :E<CR>
" load these plugins
" mkdir ~/.vim/bundle
" cd ~/.vim/bundle
" git clone <each plugin>
set runtimepath^=~/.vim/bundle/textutil
set runtimepath^=~/.vim/bundle/vim-markdown

