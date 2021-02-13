" init.vim        created 1/19/21

let mapleader=" "

"""""""""""""""""""""""""""""""""" Plugins
"
call plug#begin('~/.vim/plugged')
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'raimondi/delimitmate'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp_extensions.nvim'
"Plug 'nvim-treesitter/nvim-treesitter'
"Plug 'nvim-treesitter/completion-treesitter'

Plug 'Chiel92/vim-autoformat'
call plug#end()

set exrc
set relativenumber
set number
set nohlsearch
set cursorline
set showmatch
set hidden
set noerrorbells
set nowrap
set noswapfile
set nobackup
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=120
set updatetime=50
set undodir=~/.vim/undodir
set undofile
set termguicolors
set cmdheight=1
set ignorecase
set smartcase
set wildmenu
set wildmode=list,full
set lazyredraw

set splitbelow
set splitright

if has ('nvim')
    set clipboard=unnamedplus
    set inccommand=nosplit
    set spelllang=en
endif

"""""""""""""""""""""""""""""""""""" Tabs
"

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cindent
filetype plugin indent on

set fo-=a fo-=t fo=r fo-=o
setlocal omnifunc=v:lua.vim.lsp.omnifunc

""""""""""""""""""""""""""""""""""" remaps
"
vnoremap H <gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap L >gv

""""""""""""""""""""""""""""""""""" Colors
"

colorscheme gruvbox
"highlight Normal guibg=none
"highlight LineNr guifg=#5eacd3
highlight LineNr guifg=#aed75f

""""""""""""""""""""""""""""""""""" LSP
"

set completeopt=menuone,noinsert,noselect
set shortmess+=c
let g:completion_enable_auto_paren = 1

nnoremap <leader>vd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vsh <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>vrr <cmd>lua vim.lsp.buf.reference()<CR>
nnoremap <leader>vrn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vld <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

nnoremap <leader>c <cmd>!cargo clippy
inoremap <expr> <TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
inoremap <expr> <S-TAB> pumvisible() ? "\<C-n>" : "\<S-TAB>"

imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

let g:completion_matching_strategy_list=['exact', 'substring', 'fuzzy']
lua require'lspconfig'.rust_analyzer.setup{on_attach=require'completion'.on_attach}
lua require'lspconfig'.gopls.setup{on_attach=require'completion'.on_attach}

nnoremap <leader>g[ <cmd>lua vim.lsp.diagnostic.goto_prev()
nnoremap <leader>g] <cmd>lua vim.lsp.diagnostic.goto_next()

lua <<EOF
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
virtual_text = true,
signs = true,
update_in_insert = true
}
)
EOF

""""""""""""""""""""""""""""""""""" Misc
"
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function! FileSize() abort
    let bytes = getfsize(expand(@%))
    if (bytes >= 1024*1024)
        return printf('~%.1f MiB', bytes/(1024*1024.0))
    elseif (bytes > 1024)
        return printf('~%.1f KiB', bytes/1024.0)
    elseif (bytes <= 0)
        return '0 B'
    else
        return bytes . ' B'
    endif
endfunction

augroup REACTOR
    autocmd!

    autocmd BufWritePre * :call TrimWhitespace()
    autocmd BufWrite * :Autoformat
    autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
                \ lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }
augroup END

" status line
set noshowmode
let g:currentmode={'n':'NORMAL','v':'VISUAL','V':'V-LINE','^V':'V-BLOCK','i':'INSERT','R':'R','Rv':'V-REPLACE','c':'COMMAND'}

set statusline=%m
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%{FugitiveStatusline()}
set statusline+=\ \|\ %0.50f\ %y\ %r
set statusline+=[%{FileSize()}]
set statusline+=%=
set statusline+=%{strlen(&fenc)?&fenc:'none'}
set statusline+=\ \|
set statusline+=\ <0x%02B>\ \|
set statusline+=\ %p%%
set statusline+=\ \|\ %l/%L,%-3c




