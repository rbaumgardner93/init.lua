return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"folke/lazydev.nvim",
		"rafamadriz/friendly-snippets",
	},
	opts = {
		keymap = {
			preset = "default",
		},
		completion = {
			documentation = { auto_show = false, auto_show_delay_ms = 500 },
		},
		sources = {
			default = { "lsp", "path", "snippets", "lazydev" },
			providers = {
				lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
			},
		},
		fuzzy = { implementation = "lua" },
		signature = { enabled = true },
	},
}
