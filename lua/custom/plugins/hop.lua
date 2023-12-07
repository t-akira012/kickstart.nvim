return {
	'phaazon/hop.nvim',
	config = function()
		require('hop').setup({ keys = 'qwerasdfyuiophjkl' })
		vim.keymap.set('n', '<leader><leader>', '<CMD>HopChar2<CR>', { silent = true })
	end
}
