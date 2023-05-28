return {
	"voldikss/vim-floaterm",
	config = function()
		vim.keymap.set('n', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		vim.keymap.set('v', ',,', '<CMD>FloatermToggle<CR>', { silent = true })
		vim.keymap.set('t', '<ESC>', '<CMD>FloatermToggle<CR>', { silent = true })
		-- vim.keymap.set('n', '<C-l>', '<CMD>FloatermToggle<CR>', { silent = true })
		-- vim.keymap.set('v', '<C-l>', '<CMD>FloatermToggle<CR>', { silent = true })
		-- vim.keymap.set('t', '<C-l>', '<CMD>FloatermToggle<CR>', { silent = true })
		local function floaterm_toggle()
			-- TODO: タブラベルと紐つける
			vim.api.nvim_command('FloatermToggle tab' .. vim.fn.tabpagenr())
		end

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
