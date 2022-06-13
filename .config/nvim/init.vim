""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -=- Neovim Configuration
" Email: reactorxiv@gmail.com
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
set smartindent
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=120
set updatetime=50
set undodir=~/.config/nvim/undodir
set undofile
set termguicolors
set cmdheight=1
set ignorecase
set smartcase

"""""""""""""""""""""""""""""""""""" Tabs
"
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set cindent

"""""""""""""""""""""""""""""""""""" Mappings
"
let mapleader = " "

vnoremap H <gv
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap L >gv

nnoremap <leader>/ :call utils#toggleComment()<cr>
vnoremap <leader>/ :call utils#toggleComment()<cr>gv
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>


""""""""""""""""""""""""""""""""""" Plugins
" auto install vim-plug and plugins:

let plug_install = 0
let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
if !filereadable(autoload_plug_path)
    execute '!curl -fL --create-dirs -o ' . autoload_plug_path . ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
    execute 'source ' . fnameescape(autoload_plug_path)
    let plug_install = 1
endif
unlet autoload_plug_path

call plug#begin(stdpath('config') . '/plugged')

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" LSP and Snips
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
"Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'simrat39/rust-tools.nvim'


Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'


" Visual
Plug 'gruvbox-community/gruvbox'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'
Plug 'simrat39/symbols-outline.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Misc
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

" Cleanup
Plug 'sbdchd/neoformat'

call plug#end()
call plug#helptags()


" auto install vim-plug and plugins:
if plug_install
    PlugInstall --sync
endif
unlet plug_install


""""""""""""""""""""""""""""""""""" LSP
"
set completeopt=menuone,noinsert,noselect
set shortmess+=c
let g:completion_enable_auto_paren = 1


""""""""""""""""""""""""""""""""""" Misc
"

colorscheme gruvbox
"highlight Normal guibg=none
"highlight LineNr guifg=#5eacd3
highlight LineNr guifg=#aed75f

augroup REACTOR
    autocmd!
    autocmd BufWritePre * :call utils#trimWhitespace()
    autocmd BufWrite * :Neoformat
    "autocmd CursorHold * lua vim.lsp.diganostic.show_line_diagnostics()
"    autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
"     \ lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = 'Comment', enabled = {'TypeHint', 'ChainingHint', 'ParameterHint'} }
augroup END

augroup TEXTIT
    autocmd!
    autocmd BufNewFile,BufRead *.txt setfiletype text
    autocmd FileType text setlocal wrap linebreak nolist
augroup END

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroug='IncSearch', timeout=400}
augroup END

function! LspReport() abort
	if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
 	    let hints = luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })")
 	    let warnings = luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })")
 	    let errors = luaeval("#vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })")
        return '+' . hints . ' ~' . warnings . ' -' . errors
    else
        return ''
    endif
endfunction

function! FileSize()
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

" status line
set noshowmode
let g:currentmode={"n": "NORMAL", "no": "NORMAL·OPERATOR PENDING", "v": "VISUAL",
    \ "V": "V·LINE", "\<C-V>": "V·BLOCK", "s": "SELECT", "S": "S·LINE", "^S": "S·BLOCK",
    \ "i": "INSERT", "R": "REPLACE", "Rv": "V·REPLACE", "c": "COMMAND", "cv": "VIM EX",
    \ "ce": "Ex", "r": "PROMPT", "rm": "MORE", "r?": "CONFIRM", "!": "SHELL", "t": "TERMINAL"}

set statusline=
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%{FugitiveStatusline()}
set statusline+=\ \|\ %0.50f\ %y\ %r
set statusline+=\ %{LspReport()}
set statusline+=%=
set statusline+=[%{FileSize()}]
set statusline+=\ \|
set statusline+=\ %{strlen(&fenc)?&fenc:'none'}
set statusline+=\ \|
set statusline+=\ <0x%02B>\ \|
set statusline+=\ %p%%
set statusline+=\ \|\ %l,%-3c


let g:UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
let g:UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
let g:UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'

lua << EOF


-- Insert mode keys - quick go to stand end end of line and delete char
vim.keymap.set('i', '<C-A>', '<HOME>')
vim.keymap.set('i', '<C-E>', '<END>')
vim.keymap.set('i', '<C-D>', '<DEL>')

require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "python",
        "go",
        "lua",
        "yaml",
        "bash",
        "c",
        "cpp",
        "rust",
    },
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = { },
    highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- list of language that will be disabled
        disable = { "" },
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    textobjects = {
      enable = true,
    },
    indent = {
        -- dont enable this, messes up python indentation
        enable = true,
        disable = { "python" },
    },
}

-- Change diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = "✗", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "!", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInformation", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- global config for diagnostic
vim.diagnostic.config({
  underline = false,
  virtual_text = true,
  signs = true,
  severity_sort = true,
})

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line-1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        --["<CR>"] = cmp.mapping.confirm { select = true },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ['<C-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-g>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'luasnips' }, -- For ultisnips users.
      { name = 'omni'     },
      { name = 'path'     },
      { name = 'buffer', keyword_length = 2,
        option = {
            -- include all buffers
            get_bufnrs = function()
             return vim.api.nvim_list_bufs()
            end
            -- include all buffers, avoid indexing big files
            -- get_bufnrs = function()
              -- local buf = vim.api.nvim_get_current_buf()
              -- local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
              -- if byte_size > 1024 * 1024 then -- 1 Megabyte max
                -- return {}
              -- end
              -- return { buf }
            -- end
      }},  -- end of buffer
    }),
    flags = {
        debounce_text_changes = 150,
    },
    completion = {
        keyword_length = 2,
        completeopt = "menu,noselect"
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' },
    },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' },
    }),
})


local fn = vim.fn
local api = vim.api
local lsp = vim.lsp

local utils = require("utils")

local custom_attach = function(client, bufnr)
  -- Mappings.
  local opts = { silent = true, buffer = bufnr }
  local opts2 = { focusable = false, close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                  border = 'rounded', source = 'always',  prefix = ' '}
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-h>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
    --* vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float(nil, {{opts2}, scope="line"}), opts)
    vim.keymap.set("n", "vrr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
    vim.keymap.set("n", "<leader>rca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.formatting, opts)
    --* vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist({open = true}), opts)

  vim.api.nvim_create_autocmd("CursorHold", {
    buffer=bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',  -- show source in diagnostic popup window
        prefix = ' '
      }

      if not vim.b.diagnostics_pos then
        vim.b.diagnostics_pos = { nil, nil }
      end

      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      if (cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2]) and
        #vim.diagnostic.get() > 0
      then
          vim.diagnostic.open_float(nil, opts)
      end

      vim.b.diagnostics_pos = cursor_pos
    end
  })

  -- Set some key bindings conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting_sync, opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("x", "<space>f", vim.lsp.buf.range_formatting, opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.
  if client.resolved_capabilities.document_highlight then
    vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]])
  end

  if vim.g.logging_level == 'debug' then
    local msg = string.format("Language server %s started!", client.name)
    vim.notify(msg, 'info', {title = 'Nvim-config'})
  end
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lspconfig = require("lspconfig")

if utils.executable('pylsp') then
  lspconfig.pylsp.setup({
    on_attach = custom_attach,
    settings = {
      pylsp = {
        plugins = {
          pylint = { enabled = true, executable = "pylint" },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
          jedi_completion = { fuzzy = true },
          pyls_isort = { enabled = true },
          pylsp_mypy = { enabled = true },
        },
      },
    },
    flags = {
      debounce_text_changes = 200,
    },
    capabilities = capabilities,
  })
else
  vim.notify("pylsp not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('clangd') then
    lspconfig.clangd.setup({
        on_attach = custom_attach,
        capabilities = capabilities,
        filetypes = { "c", "cpp", "objc", "objcpp" },
        cmd = {
            "clangd",
            "--background-index",
            "--suggest-missing-includes"
        },
        init_options = {
            compilationDatabasePath="cmake-build",
        },
        flags = {
            debounce_text_changes = 500,
        },
})
else
    vim.notify("clangd not found!", 'warn', {title = 'Nvim-config'})
end

if utils.executable('gopls') then
    lspconfig.gopls.setup({
        on_attach = custom_attach,
        capabilities = capabilities,
        filetypes = { "go", "mod" },
        settings = {
	    gopls = {
	        analyses = {
	            unusedparams = true,
	        },
	    staticcheck = true,
        },
        },
        flags = {
            debounce_text_changes = 500,
        },
})
else
    vim.notify("gopls not found!", 'warn', {title = 'Nvim-config'})
end

local opts = {
    tools = {
        autoSetHints = true,
        hover_with_actions = true,
        inlay_himts = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
          },
        cargo = {
          allFeatures = true
          },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy"
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true
          },
        },
      }
    },
}
require('rust-tools').setup(opts)

--if utils.executable('rust-analyzer') then
--    lspconfig.rust_analyzer.setup({
--        on_attach = custom_attach,
--        capabilities = capabilities,
--        filetypes = { "rs" },
--        settings = {
--            rust = {
--                unstable_features = true,
--                build_on_save = false,
--                all_features = true,
--            },
--        },
--        flags = {
--            debounce_text_changes = 500,
--        },
--})
--else
--    vim.notify("rust-analyzer not found!", 'warn', {title = 'Nvim-config'})
--end

local snippets_paths = function()
	local plugins = { "friendly-snippets" }
	local paths = {}
	local path
	local root_path = "~/.config/nvim/plugged/"
	for _, plug in ipairs(plugins) do
		path = root_path .. plug
		if vim.fn.isdirectory(path) ~= 0 then
			table.insert(paths, path)
		end
	end
	return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
	paths = snippets_paths(),
	include = nil, -- Load all languages
	exclude = {},
})


local opts = { highlight_hovered_item = true, show_guides = true }
require("symbols-outline").setup(opts)

require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        throttle = true, -- Throttles plugin updates (may improve performance)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        show_all_context = show_all_context,
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                "function",
                "method",
                "for",
                "while",
                "if",
                "switch",
                "case",
            },

            rust = {
                "loop_expression",
                "impl_item",
            },

            typescript = {
                "class_declaration",
                "abstract_class_declaration",
                "else_clause",
            },
        },
    })
EOF



