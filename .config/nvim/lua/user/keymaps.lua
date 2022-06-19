
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local imap = require("utils").imap
local nmap = require("utils").nmap
local vmap = require("utils").vmap
local xmap = require("utils").xmap

-- Normal Mode --
nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

-- Window Nav
nmap("<leader><CR>", "<cmd>so " .. vim.fn.stdpath('config') .. "/init.lua<CR>")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

nmap("<F4>", "<cmd>Telescope resume<CR>")
nmap("<F5>", "<cmd>Telescope commands<CR>")

nmap("<leader>ct", "<cmd>TSContextToggle<CR>")

-- Resize w/ Arrow
nmap("<C-Up>", ":resize -2<CR>")
nmap("<C-Down>", ":resize +2<CR>")
nmap("<C-Left>", ":vertical resize -2<CR>")
nmap("<C-Right>", ":vertical resize +2<CR>")

-- Navigate buffers
nmap("<S-l>", ":bnext<CR>")
nmap("<S-h>", ":bprevious<CR>")

-- Move text up and down
nmap("<A-j>",   "<ESC>:m .+1<CR>==gi")
nmap("<A-k>", "<ESC>:m .-2<CR>==gi")

nmap( "<C-f>", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>")

-- Insert Mode --
-- QUick Nav in Insert
imap("<C-a>","<HOME>")
imap("<C-e>","<END>")
imap("<C-d>","<DEL>")

-- Visual Mode --
-- Stay in indent mode
vmap("<", "<gv")
vmap(">", ">gv")

-- Move Text up and down
vmap("<A-Up>",   ":m .+1<CR>==")
vmap("<A-Down>", ":m .-2<CR>==")

-- Visual Block --
-- Move Text up and down
xmap("J", ":move '>+1<CR>gv-gv")
xmap("K", ":move '<-2<CR>gv-gv")
xmap("<A-j>", ":move '>+1<CR>gv-gv")
xmap("<A-k>", ":move '<-2<CR>gv-gv")

