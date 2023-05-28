return {
	'nvim-tree/nvim-tree.lua',
	config = function()
		vim.keymap.set('n', '<C-b>', '<CMD>NvimTreeToggle<CR>', { silent = true })
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		vim.opt.termguicolors = true

		-- keybinding
		local function fix_keybind(bufnr)
			local api = require('nvim-tree.api')

			api.config.mappings.default_on_attach(bufnr)
			local function opts(desc)
				return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.set('n', '<CR>', api.node.open.vertical, opts('Open: Vertical Split'))

		end

		-- setup
		require("nvim-tree").setup({
			sort_by = "case_sensitive",
			view = {
				width = 60,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = false,
			},
			actions = {
				open_file = {
					quit_on_open = false,
					resize_window = true,
					window_picker = {
						enable = false,
						picker = "default",
						chars = "123456789",
						exclude = {
							filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
							buftype = { "nofile", "terminal", "help" },
						},
					},
				},
			},
			on_attach = fix_keybind,
		})

	end
}
