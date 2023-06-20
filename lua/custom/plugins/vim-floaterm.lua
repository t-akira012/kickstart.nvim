return {
	"voldikss/vim-floaterm",
	config = function()
		local function floaterm_toggle()
			-- TODO: タブラベルと紐つける
			vim.api.nvim_command('FloatermToggle tab' .. vim.fn.tabpagenr())
		end

		vim.keymap.set('n', '<C-q>', floaterm_toggle, { silent = true })
		vim.keymap.set('t', '<C-q>', '<CMD>FloatermHide<CR>', { silent = true })

		-- vim.keymap.set('t', '<C-q>', floaterm_toggle, { silent = true })
		-- vim.keymap.set('n', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		-- vim.keymap.set('v', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		-- vim.keymap.set('t', '<ESC>', '<CMD>FloatermHide<CR>', { silent = true })
		-- vim.keymap.set('t', '<C-c>', '<CMD>FloatermKill google<CR>', { silent = true })
		-- vim.keymap.set('t', '<C-g>', '<CMD>FloatermShow google<CR>', { silent = true })
		-- vim.keymap.set('n', '<C-g>', ':W3mGoogle ', { silent = false })
		-- vim.api.nvim_create_user_command('W3mGoogle',
		-- 	'FloatermNew --name=google --autoclose=1 w3m google.com/search\\?q=<q-args>',
		-- 	{ nargs = 1 })

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
