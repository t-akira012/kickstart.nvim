return {
	"voldikss/vim-floaterm",
	config = function()
		-- vim.keymap.set('n', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		-- vim.keymap.set('v', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		vim.keymap.set('t', '<ESC>', '<CMD>FloatermHide<CR>', { silent = true })
		vim.keymap.set('t', '<C-g>', '<CMD>FloatermShow google<CR>', { silent = true })
		vim.keymap.set('t', '<C-c>', '<CMD>FloatermKill google<CR>', { silent = true })
		local function floaterm_toggle()
			-- TODO: タブラベルと紐つける
			vim.api.nvim_command('FloatermToggle tab' .. vim.fn.tabpagenr())
		end

		vim.api.nvim_create_user_command('W3mGoogle',
			'FloatermNew --name=google --autoclose=1 w3m google.com/search\\?q=<q-args>',
			{ nargs = 1 })

		vim.keymap.set('n', '<C-g>', ':W3mGoogle ', { silent = false })
		vim.keymap.set('n', '<C-l>', floaterm_toggle, { silent = true })
		vim.keymap.set('t', '<C-l>', floaterm_toggle, { silent = true })
		vim.keymap.set('t', '<C-l>', '<CMD>FloatermHide<CR>', { silent = true })

		vim.cmd([[
			augroup vimrc_floaterm
				autocmd!
				autocmd QuitPre * FloatermKill!
			augroup END
		]])
	end
}
