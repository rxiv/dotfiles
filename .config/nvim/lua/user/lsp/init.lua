local fn = vim.fn
local api = vim.api
local lsp = vim.lsp

local utils = require("utils")

local custom_attach = function(client, bufnr)
  -- Mappings.
  local opts = { silent = true, buffer = bufnr }
  local opts2 = { focusable = false, close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                  border = 'rounded', source = 'always',  prefix = ' '}
    api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    vim.keymap.set("n", "gD", lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", lsp.buf.definition, opts)
    vim.keymap.set("n", "<C-]>", lsp.buf.definition, opts)
    vim.keymap.set("n", "gi", lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-h>", lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>vws", lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(lsp.buf.list_workspace_folders())) end, opts)
    vim.keymap.set("n", "<leader>vrn", lsp.buf.rename, opts)
    --* vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float(nil, {{opts2}, scope="line"}), opts)
    vim.keymap.set("n", "vrr", lsp.buf.references, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setqflist({open = true}) end, opts)
    vim.keymap.set("n", "<leader>rca", lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lf", lsp.buf.formatting, opts)
    --* vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist({open = true}), opts)

    api.nvim_create_autocmd("CursorHold", {
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
  if client.server_capabilities.document_formatting then
    vim.keymap.set("n", "<space>f", lsp.buf.formatting_sync, opts)
  end
  if client.server_capabilities.document_range_formatting then
    vim.keymap.set("x", "<space>f", lsp.buf.range_formatting, opts)
  end

  -- The blow command will highlight the current variable and its usages in the buffer.

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
          pyflakes = { enabled = true },
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


-- local sumneko_binary_path = '/usr/bin/lua-language-server'
local sumneko_binary_path = fn.exepath("lua-language-server")
if sumneko_binary_path ~= "" then
    local sumneko_root_path = fn.fnamemodify(sumneko_binary_path, ":h:h:h")

    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    lspconfig.sumneko_lua.setup({
        on_attach = custom_attach,
        cmd = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" },
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = runtime_path,
                },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
            },
        },
        capabilities = capabilities,
    })
else
    vim.notify("sumneko not found!", 'warn', {title = 'Nvim-config'})
end

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
lsp.handlers["textDocument/hover"] = lsp.with(lsp.handlers.hover, {
  border = "rounded",
})

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

