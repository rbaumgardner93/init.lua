-- options

-- general
vim.opt.number = true -- make line numbers default
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current li
vim.opt.wrap = false -- don't wrap lines
vim.opt.scrolloff = 10 -- keep 10 lines above and below cursor

-- indentation
vim.opt.smartindent = true -- smart auto-indenting
vim.opt.autoindent = true -- copy indent from current line

-- search
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case insensetive if uppercase in search
vim.opt.hlsearch = false -- don't highlight search results
vim.opt.incsearch = true -- show matches as you type
vim.opt.inccommand = "split" -- preview substitutions as you type

-- visual
vim.opt.guicursor =
	"n-v-c:block,i:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Curosr/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

vim.opt.termguicolors = true -- enable 24-bit colors
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.colorcolumn = "80" -- show color column at 80 characters
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.matchtime = 0
vim.opt.cmdheight = 1 -- command line height
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
vim.opt.winborder = "rounded" -- default border style of floting windows
vim.opt.conceallevel = 0 -- don't hide markup
vim.opt.concealcursor = "" -- don't hide cursor line markup
vim.opt.lazyredraw = true -- don't redraw during macros
vim.opt.synmaxcol = 300 -- don't syntax highlihgt after 300

-- files
vim.opt.backup = false -- don't create backup files
vim.opt.writebackup = false -- don't create backup before writing
vim.opt.swapfile = false -- don't create swap files
vim.opt.undofile = true -- persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- undo directory
vim.opt.autoread = true -- auto reload files changed outside vim
vim.opt.autowrite = false -- don't auto save
vim.opt.updatetime = 300 -- write to swapfile after 300ms
vim.opt.timeoutlen = 500 -- time in ms to wait for sequence to complete
vim.opt.ttimeoutlen = 0 -- time in ms to for key code timeot to complete

-- editing
vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error bells
vim.opt.backspace = "indent,eol,start" -- better backspace behavior
vim.opt.autochdir = false -- don't auto change directory
vim.opt.iskeyword:append("-") -- treat dash as part of word
vim.opt.path:append("**") -- include subdirectories in search
vim.opt.selection = "exclusive" -- selection behavior
vim.opt.mouse = "a" -- enable mouse support
vim.opt.modifiable = true -- allow buffer modification
vim.opt.confirm = true -- use dialog to confirm unsaved changes
-- schedule the setting after 'UiEnter' because it can increase startup-time
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus" -- use system clipboard
end)

-- splits
vim.opt.splitright = true -- vertical splits go to the right
vim.opt.splitbelow = true -- horizontal splits go below

-- keymaps

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- general
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", ":w!<CR>", { desc = "Save file" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line up" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent" })
vim.keymap.set("v", "<", "<gv", { desc = "Dedent" })

-- diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- navigation
-- basic
vim.keymap.set("n", "J", "mzJ`z", { desc = "Move line above and keep centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Keep centered when navigating forward" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep centered when navigating backward" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep it centered when moving down a file" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep it centered when moving up a file" })

-- fuzzy finder
vim.keymap.set("n", "<leader>sd", "<cmd>FzfLua diagnostics_workspace<CR>", { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sf", "<cmd>FzfLua files<CR>", { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<CR>", { desc = "[S]earch [G]rep" })
vim.keymap.set("n", "<leader>sh", "<cmd>FzfLua helptags<CR>", { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sr", "<cmd>FzfLua resume<CR>", { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sw", "<cmd>FzfLua grep_cword<CR>", { desc = "[S]earch [W]ord" })

-- files
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory" })

-- autocommands
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("HighlightYankGroup", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachGroup", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/implementation") then
			-- Create a keymap for vim.lsp.buf.implementation ...
			vim.keymap.set("n", "grd", "<cmd>FzfLua lsp_definitions<CR>", { desc = "[G]oto [D]efinition" })
		end

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			-- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			-- client.server_capabilities.completionProvider.triggerCharacters = chars

			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end

		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if
			not client:supports_method("textDocument/willSaveWaitUntil")
			and client:supports_method("textDocument/formatting")
		then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("FormattingGroup", { clear = false }),
				buffer = args.buf,
				callback = function()
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end
	end,
})

-- plugin initialization
vim.pack.add({
	{
		src = "https://github.com/Saghen/blink.cmp",
		version = vim.version.range("1.0"),
	},
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/NMAC427/guess-indent.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/echasnovski/mini.icons" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "master",
	},
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
})

-- plugin setup

-- tokyonight.nvim
require("tokyonight").setup({
	transparent = true,
})

-- colorscheme
vim.cmd([[ colorscheme tokyonight]])

-- lsp configuration

-- typescript
vim.lsp.enable("ts_ls")

-- lua
vim.lsp.enable("lua_ls")
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = { vim.env.VIMRUNTIME },
				checkThirdParty = false,
			},
		},
	},
})

-- blink.cmp
require("blink-cmp").setup({
	keymap = {
		preset = "default",
	},
	completion = {
		documentation = { auto_show = false, auto_show_delay_ms = 500 },
	},
	sources = {
		default = { "lsp", "path" },
	},
	fuzzy = { implementation = "lua" },
	signature = { enabled = true },
})

-- conform.nvim
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},
		javascriptreact = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},
		typescript = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},
		typescriptreact = {
			"prettierd",
			"prettier",
			stop_after_first = true,
		},
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})

-- fzf.lua
require("fzf-lua").setup({
	"ivy",
})

-- gitsigns.nvim
require("gitsigns").setup({
	on_attach = function()
		local gitsigns = require("gitsigns")
		vim.keymap.set("x", "<leader>s", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)

		vim.keymap.set("x", "<leader>u", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end)
	end,
})

-- guess-indent.nvim
require("guess-indent").setup({})

-- mini.icons
require("mini.icons").setup()

-- mason
require("mason").setup()

-- mason-lspconfig.nvim
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls", "ts_ls" },
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "bash", "diff", "html", "lua", "markdown", "typescript", "javascript" },
	auto_install = true,
	highlight = {
		enable = true,
	},
	ignore_install = {},
	indent = { enable = true },
	sync_install = false,
	modules = { "nvim-treesitter.configs" },
})

-- oil.nvim
require("oil").setup()
