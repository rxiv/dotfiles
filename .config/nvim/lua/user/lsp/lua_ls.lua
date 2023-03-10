return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
--        library = api.nvim_get_runtime_file("", true),
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true
        },
      },
      telemetry = {
        enable = false,
      }
    }
  }
}
