return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
			})

			vim.cmd([[ colorscheme tokyonight]])
		end,
	},
	{
		"scottmckendry/cyberdream.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
	},
}
