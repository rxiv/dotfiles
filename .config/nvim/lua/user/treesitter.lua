local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = {
            "python",
            "go",
            "lua",
            "yaml",
            "bash",
            "help",
            "javascript",
            "c",
            "cpp",
            "rust",
            "zig",
            "css",
            "html",
            "json",
        }, -- one of "all" or a list of languages
        sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
        ignore_install = { "" }, -- List of parsers to ignore installing
        highlight = {
    -- use_languagetree = true,
                enable = true, -- false will disable the whole extension
                -- disable = { "css", "html" }, -- list of language that will be disabled
                disable = { "" }, -- list of language that will be disabled
                -- additional_vim_regex_highlighting = true,
	},
--	autopairs = {
--		enable = true,
--	},
	indent = {
            enable = true,
            disable = { "python", "css" }
        },
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
--	autotag = {
--		enable = true,
--		disable = { "xml" },
--	},
})
