local config = function()
	-- lsp configuration

	-- typescript
	vim.lsp.enable("ts_ls");
end

return {
	"neovim/nvim-lspconfig",
	config = config,
	lazy = false,
}
