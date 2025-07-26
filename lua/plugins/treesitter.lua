return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "bash", "diff", "html", "lua", "markdown", "typescript", "javascript" },
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = { enable = true },
	},
}
