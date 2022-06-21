local fn = vim.fn
local call = vim.call
local pinstall = 0

local config_path = fn.stdpath('config')
local plug_url = 'https://raw.github.com/junegunn/vim-plug/master/plug.vim'
local plug_path = config_path .. '/autoload/plug.vim'
local plug_install = config_path .. '/plugged'

if fn.filereadable(fn.expand(plug_path)) == 0 then
    vim.cmd('silent !curl -fLo ' .. plug_path .. ' --create-dirs ' .. plug_url)
    vim.cmd('silent !source ' .. fn.fnameescape(plug_path) )
    pinstall = 1
end

local Plug = vim.fn['plug#']

call('plug#begin', plug_install)

-- Telescope
--Plug('nvim-lua/popup.vim')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = function() vim.call('make') end})
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug('kyazdani42/nvim-web-devicons')

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter' , {['do'] = function() vim.call(':TSUpdate') end } )
Plug('romgrk/nvim-treesitter-context')
Plug('simrat39/symbols-outline.nvim')

-- LSP
Plug('neovim/nvim-lspconfig')
Plug('RRethy/vim-illuminate')
Plug('simrat39/rust-tools.nvim')

-- Completion
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-emoji')
Plug('saadparwaiz1/cmp_luasnip')

-- Snip
Plug('L3MON4D3/LuaSnip')
Plug('rafamadriz/friendly-snippets')

-- Visual
Plug('gruvbox-community/gruvbox')
Plug('lunarvim/darkplus.nvim')

-- Misc
Plug('tpope/vim-surround')
Plug('cohama/lexima.vim')
Plug('rcarriga/nvim-notify')
Plug('nvim-lualine/lualine.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('cappyzawa/trim.nvim')

--Git
Plug("lewis6991/gitsigns.nvim")
Plug('tpope/vim-fugitive')

call('plug#end')
call('plug#helptags')

if pinstall == 1 then
    call('PlugInstall --sync')
end
