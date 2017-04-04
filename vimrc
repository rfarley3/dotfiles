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
" the default OS X vim is -clipboard, but the default Homebrew vim has it: brew install vim
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
set runtimepath^=~/.vim/bundle/zenburn
set runtimepath^=~/.vim/bundle/gitgutter
set runtimepath^=~/.vim/bundle/fugitive
let g:zenburn_high_Contrast=1
colorscheme zenburn


fun! TrimTag(tag_str)
  let trimmed = a:tag_str
  if trimmed == ''
    return trimmed
  endif
  " remove : and any comments or trailing spaces
  let trimmed = substitute(trimmed, ':.*$', '', '')
  " trim surrounding whitespace
  let trimmed = substitute(trimmed, '^\s*\(.\{-}\)\s*$', '\1', '')
  let trimmed = substitute(trimmed, '^\(class\|def\)\s*', '', '')
  " remove self from the arg list, handling args on both single and split lines
  let trimmed = substitute(trimmed, 'self,\s*', '', '')
  " handle self when only arg
  let trimmed = substitute(trimmed, '(self)', '()', '')
  " don't show class's super if only object
  let trimmed = substitute(trimmed, '(object)', '', '')
  if trimmed == ''
    return trimmed
  elseif trimmed =~ '($'
    let trimmed .= '...)'
  elseif trimmed =~ ',$'  " aka !~ ')$'
    let trimmed .= ' ...)'
  endif
  return trimmed
endfun
fun! GetTagPath()
  let parent_linenum = line(".")
  let parent_line = getline(parent_linenum)
  if parent_line !~ '^\s*\(class\|def\) '
    let parent_linenum = search('^\s*\(class\|def\) .*', 'bWn')
	if parent_linenum == 0
	  return '.'
	endif
    let parent_line = getline(parent_linenum)
  endif
  let parent_name = '.' . TrimTag(parent_line)
  if parent_line[0] != ' '
    return parent_name
  endif
  let lnum = line(".")
  let col = col(".")
  call search("\\%" . parent_linenum . "l" . "\\%0c")
  let gparent_linenum = search('^\(class\|def\) .*', 'bWn')
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
  if gparent_linenum == 0
	return parent_name
  endif
  let gparent_line = getline(gparent_linenum)
  let gparent_name = '.' . TrimTag(gparent_line)
  return gparent_name . parent_name
endfun
fun! ShowTagPath()
  echohl ModeMsg
  echo GetTagPath()
  echohl None
endfun
" press t at anytime to update this
nnoremap <C-f>   :call ShowTagPath() <CR>
inoremap <C-f>   <Esc>:call ShowTagPath() <CR>
" or enable a refresh anytime your move the cursor
" autocmd  CursorMoved  *.py   :call ShowTagPath()

