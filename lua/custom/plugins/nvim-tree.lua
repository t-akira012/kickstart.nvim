return {
	'nvim-tree/nvim-tree.lua',
	config = function()
		vim.keymap.set('n', '<C-b>', '<CMD>NvimTreeToggle<CR>', { silent = true })
		-- disable netrw at the very start of your init.lua
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- set termguicolors to enable highlight groups
		vim.opt.termguicolors = true

		-- OR setup with some options
		require("nvim-tree").setup({
			sort_by = "case_sensitive",
			view = {
				width = 60,
			},
			renderer = {
				group_empty = true,
			},
			filters = {
				dotfiles = true,
			},
		})
	end
}
