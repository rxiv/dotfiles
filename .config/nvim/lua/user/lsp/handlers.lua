local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.setup = function()
    local icons = require "user.icons"
    local signs = {
        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
        { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, {texthl = sign.name, text = sign.text, numhl = ""})
    end

local config = {
        virtual_text = false,
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_highlight_document(client)
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
end

local map = vim.api.nvim_buf_set_keymap

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    --local opts2 = { focusable = false, close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --              border = 'rounded', source = 'always',  prefix = ' '}

    map(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    map(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    map(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    map(bufnr, "n", "<C-]>", "<cmd>lua vim.lsp.buf.definition<CR>", opts)
    map(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation<CR>", opts)
    map(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references<CR>", opts)
    map(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover<CR>", opts)
    map(bufnr, "n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help<CR>", opts)
    map(bufnr, "n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder<CR>", opts)
    map(bufnr, "n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder<CR>", opts)
    map(bufnr, "n", "<leader>vws", "<cmd>lua vim.lsp.buf.workspace_symbol<CR>", opts)
    --map(bufnr, "n", "<leader>wl", function() print(vim.inspect(lsp.buf.list_workspace_folders())) end, opts)
    map(bufnr, "n", "<leader>vrn", "<cmd>lua vim.lsp.buf.rename<CR>", opts)
    --* vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float(nil, {{opts2}, scope="line"}), opts)
    map(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev<CR>", opts)
    map(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next<CR>", opts)
    map(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setqflist({open = true})", opts)
    map(bufnr, "n", "<leader>rca", "<cmd>lua vim.lsp.buf.code_action<CR>", opts)
    map(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting<CR>", opts)
    map(bufnr, "n", "<leader>ql", "<cmd>lua vim.diagnostic.setloclist({open = true})<CR>", opts)
end

M.on_attach = function(client, bufnr)

    local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if not status_cmp_ok then
        return
    end

    M.capabilities.textDocument.completion.completionItem.snippetSupport = true
    M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

    if client == 'clangd' then
        local clangd_cmp = M.capabilities
        clangd_cmp.textDocument.semanticHighlighting = true
        clangd_cmp.offsetEncoding = 'utf-8'
        M.capabilities = clangd_cmp
    end

    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

return M
