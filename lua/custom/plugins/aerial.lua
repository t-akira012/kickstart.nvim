return {
	'stevearc/aerial.nvim',
	config = function()
		require("aerial").setup({
			layout = {
				max_width = { 40, 0.3 },
				width = nil,
				min_width = 10,
				win_opts = {},
				default_direction = "prefer_left",
				placement = "window",
				resize_to_content = true,
				preserve_equality = false,
			},
		})
		vim.keymap.set('n', '<leader>a', '<CMD>AerialToggle<CR>')
	end
}
