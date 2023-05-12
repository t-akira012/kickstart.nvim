return {
	'terrortylor/nvim-comment',
	config = function()
		require("nvim_comment").setup({
			create_mappings = false,
		})
		vim.keymap.set('n', 'cc', '<CMD>CommentToggle<CR>', { silent = true })
		vim.keymap.set('v', 'cc', ':<C-u>call CommentOperator(visualmode())<CR>', { silent = true })
	end,
}
