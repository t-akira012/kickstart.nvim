return {
	'skanehira/denops-translate.vim',
	dependencies = {
		'vim-denops/denops.vim'
	},
	config = function()
		vim.keymap.set('n', 'T', '<CMD>Translate<CR>')
	end
}
