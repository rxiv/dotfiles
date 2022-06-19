local options = {
    title = true,
    spelllang = { 'en' },
    clipboard = "unnamedplus",
    fileencoding = "utf-8",
    cmdheight = 1,
    completeopt = {"menu", "menuone", "noselect"},
    conceallevel = 0,
    backspace = {"indent", "eol", "start"},
    joinspaces = true,
    pumheight = 10,
    showmode = false,
    showtabline = 0,
    smartcase = true,
    splitbelow  = true,
    splitright = true,
    swapfile = false,
    timeoutlen = 500,
    updatetime = 50,
    cursorline = true,
    colorcolumn =  { 80, 120 },

    number = true,
    relativenumber = true,
    numberwidth = 3,
    signcolumn = "yes",

    backup = false,
    writebackup = false,
    undofile = true,
    undodir = vim.fn.stdpath('config') .. '/undodir',
    --shada =  vim.fn.stdpath('config') .. '/shada',

    laststatus = 3,
    showcmd = false,
    showmatch = true,
    incsearch = true,
    ignorecase = true,
    hlsearch = true,
    list = true,
    --listchars = { tab = " ", trail = "·" , space = "⋅", eol = "↴"},
    listchars = { tab = " ", trail = "·" , space = "⋅"},
    --listchars = { tab = " ", trail = "·" },
    ruler = false,
    exrc = true,
    wrap = false,

    mouse = "a",
    guifont = "monospace:h17",
    guicursor = "n-v-c-sm:block-blinkwait50-blinkon50-blinkoff50,i-ci-ve:ver25-Cursor-blinkon100-blinkoff100,r-cr-o:hor20",
    termguicolors = true,

    scrolloff = 8,
    sidescrolloff = 8,

    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    smartindent = true,
    autoindent = true,
    cindent = true,
}

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.fillchars.eob = " "

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
	vim.opt[k] = v
end

--vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]]
