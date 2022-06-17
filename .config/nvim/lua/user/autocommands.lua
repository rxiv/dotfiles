local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local yankgrp = augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
    group = yankGrp,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 200 }
    end,
    desc = 'Highlight Yank',
})
