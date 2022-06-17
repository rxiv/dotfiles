local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local servers = {
    "gopls",
    "clangd",
    "rust_analyzer",
    "sumneko_lua",
    "pylsp",
    "bashls",
}

local opts = {}

for _, server in pairs(servers) do 
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    if server == "gopls" then
        local gopls_opts = require "user.lsp.gopls"
        opts = vim.tbl_deep_extend("force", gopls_opts, opts)
    end

    if server == "sumneko_lua" then
        local sumneko_opts = require "user.lsp.sumneko_lua"
        opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
   end

    if server == "clangd" then
        local clangd_opts = require "user.lsp.clangd"
        opts = vim.tbl_deep_extend("force", clangd_opts, opts)
    end

    if server == "pylsp" then
        local pylsp_opts = require "user.lsp.pylsp"
        opts = vim.tbl_deep_extend("force", pylsp_opts, opts)
    end
    
--    if server == "rust_analyzer" then
--        local rust_opts = require "user.lsp.rust_analyzer"
--        opts = vim.tbl_deep_extend("force", rust_opts, opts)
--    end

    lspconfig[server].setup(opts)
end

require("user.lsp.rust_analyzer")

