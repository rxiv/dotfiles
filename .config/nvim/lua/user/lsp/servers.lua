local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local servers = {
    "gopls",
    "clangd",
    "lua_ls",
    "pylsp",
}

-- local opts = {}

for _,server in pairs(servers) do
    local opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    local has_custom_opts, server_opts = pcall(require, "user.lsp." .. server)
    if has_custom_opts then
       opts = vim.tbl_deep_extend("force", server_opts, opts)
    end
    lspconfig[server].setup(opts)
end

require("user.lsp.rust_analyzer")
