return {
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
}
