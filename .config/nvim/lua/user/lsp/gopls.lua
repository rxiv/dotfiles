return {
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
}

