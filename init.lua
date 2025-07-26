-- options

-- theme & transparency
vim.cmd.colorscheme("default")

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
vim.opt.termguicolors = true -- enable 24-bit colors
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.colorcolumn = "80" -- show color column at 80 characters
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.cmdheight = 1 -- command line height
vim.opt.completeopt = "menuone,noinsert,noselect" -- completion options
vim.opt.pumheight = 10 -- popup menu height
vim.opt.pumblend = 10 -- popup menu transparency
vim.opt.winblend = 0 -- floating window transparency
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
vim.keymap.set("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Open file explorer" })

-- fuzzy finder
vim.keymap.set("n", "<leader>sf", "<cmd>FzfLua files<CR>", { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", "<cmd>FzfLua live_grep<CR>", { desc = "[S]earch [G]rep" })
vim.keymap.set("n", "<leader>sr", "<cmd>FzfLua resume<CR>", { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>sw", "<cmd>FzfLua grep_cword<CR>", { desc = "[S]earch [W]ord" })

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

require("config.lazy")
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "default" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})
