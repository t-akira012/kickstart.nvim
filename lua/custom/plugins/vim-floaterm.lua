return {
	"voldikss/vim-floaterm",
	config = function()
		vim.keymap.set('n', '<C-q>', '<CMD>FloatermToggle new<CR>', { silent = true })
		vim.keymap.set('t', '<C-q>', '<CMD>FloatermHide new<CR>', { silent = true })

		vim.keymap.set('n', '<F2>', '<CMD>FloatermToggle google<CR>', { silent = true })
		vim.keymap.set('t', '<F2>', '<CMD>FloatermToggle google<CR>', { silent = true })
		vim.keymap.set('n', '<C-g>', ':W3mGoogle ', { silent = false })
		vim.api.nvim_create_user_command('W3mGoogle',
			'FloatermNew --name=google --height=0.6 --autoclose=1 w3m google.com/search\\?q=<q-args>',
			{ nargs = 1 })

		vim.cmd([[
			let g:floaterm_width=0.99
			let g:floaterm_height=0.8
			hi FloatermBorder guibg=none guifg=cyan
			augroup vimrc_floaterm
				autocmd!
				autocmd QuitPre * FloatermKill!
			augroup END
		]])
	end
}
