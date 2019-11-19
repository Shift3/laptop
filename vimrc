set nocompatible
filetype plugin on
syntax on

let g:has_async = v:version >= 800 || has('nvim')

call plug#begin('~/.vim/bundle')
  " Plugins that do stuff.
  Plug 'DropsOfSerenity/oblivion'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'tpope/vim-abolish' " e.g crc = CoeRce Camelcase
  Plug 'tpope/vim-surround'
  Plug 'pbrisbin/vim-mkdir'
  Plug 'kana/vim-textobj-user'
  Plug 'janko-m/vim-test'
  Plug 'mattn/emmet-vim'
  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'vim-scripts/tComment'
  Plug 'tpope/vim-fugitive'

  " Rails Plugins
  Plug 'tpope/vim-bundler'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-rake'
  Plug 'tpope/vim-repeat'

  " Indentation
  Plug 'tpope/vim-sleuth'
  Plug 'editorconfig/editorconfig-vim'

  " Syntax highlighting
  Plug 'mustache/vim-mustache-handlebars'
  Plug 'leafgarland/typescript-vim'
  Plug 'pangloss/vim-javascript'
  Plug 'chrisbra/csv.vim'
  Plug 'vim-ruby/vim-ruby'

  if g:has_async
    Plug 'dense-analysis/ale'
  endif

call plug#end()

let mapleader = " "

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Use one space, not two, after punctuation.
set nojoinspaces

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1
let &colorcolumn=join(range(81,999),",")

" Numbers
set number
set scrolloff=3
set sidescroll=3
set noesckeys

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" Always use vertical diffs
set diffopt+=vertical

set ignorecase
set smartcase
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.
set history=1000
set undolevels=1000
set hidden
set ar
set incsearch
set hlsearch
set vb t_vb=

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  " autocmd BufRead,BufNewFile *.hbs set filetype=handlebars
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
augroup END

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Use Ag over Grep
set grepprg=ag\ --nogroup\ --nocolor

" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
let g:ctrlp_user_command = 'ag --literal --files-with-matches --nocolor --hidden -g "" %s'

" ag is fast enough that CtrlP doesn't need to cache
let g:ctrlp_use_caching = 0

if !exists(":Ag")
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Ag<SPACE>
endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-p>"
  endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <C-^>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<Space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" gui and non-gui specific stuff
if has("gui_running")
  set guioptions-=m  "remove menu bar
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guioptions-=L  "remove left-hand scroll bar
else
  set t_Co=256
endif

" Appearance
set background=dark
if !$VIM_INSTALL_PHASE
  colorscheme oblivion
endif

nmap <leader>h :nohlsearch<cr>

" paste in insert mode and copy in visual select mode with expected commands.
set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>
vnoremap <C-c> "+y

" expected behavior of up and down
nmap k gk
nmap j gj

" ex mode I don't even...
map Q <Nop>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
map <Leader>v :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" File Type Specific Prefs
autocmd FileType c,cpp setlocal noet ts=4 sw=4 tw=80
autocmd FileType h,hpp setlocal noet ts=4 sw=4 tw=80

au BufNewFile,BufRead *.ejs set filetype=html " ejs is html syntax
au BufWritePre *.rb :%s/\s\+$//e
au BufWritePre *.py :%s/\s\+$//e
au BufWritePre *.js :%s/\s\+$//e
au BufWritePre *.html :%s/\s\+$//e

" Package Specific Configs

" `ctrl-p`
let g:ctrlp_max_depth = 40
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

" `html.vim`
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"
let g:html_indent_inctags = "html,body,head,tbody"

" `vim-rails`
map <Leader>su :RSunittest
map <Leader>sv :RSview
map <Leader>sm :RSmodel
map <Leader>m :Rmodel
map <Leader>u :Runittest<cr>
map <Leader>vc :RVcontroller<cr>
map <Leader>vf :RVfunctional<cr>
map <Leader>vu :RVunittest<CR>
map <Leader>vm :RVmodel<cr>
map <Leader>vv :RVview<cr>
map <Leader>pu :!python -m unittest discover<cr>
map <Leader>pa :!python -m unittest discover<cr>

nmap <silent> <leader>g :make && make run<CR>

" `vim-test`
nmap <silent> <leader>s :TestNearest<CR>
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
let test#python#runner = 'djangotest'
let test#ruby#use_spring_binstub = 1

" `emmet`
let g:user_emmet_settings = {
      \  'indentation' : '  '
      \}

function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g") . "_"
  execute "normal! i#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif // " . gatename
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

" Local config
if filereadable($HOME . "/.vimrc.user")
  source ~/.vimrc.user
endif
