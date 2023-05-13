return {
	"voldikss/vim-floaterm",
	config = function()
		vim.keymap.set('n', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		vim.keymap.set('v', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		vim.keymap.set('t', '<ESC>', '<CMD>FloatermToggle<CR>', { silent = true })
		vim.cmd([[
			augroup vimrc_floaterm
				autocmd!
				autocmd QuitPre * FloatermKill!
			augroup END
		]])
	end
}
