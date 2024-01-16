return {
    --     "voldikss/vim-floaterm",
    --     config = function()
    --         vim.keymap.set('n', '<C-j>', '<CMD>FloatermToggle new<CR>', { silent = true })
    --         vim.keymap.set('t', '<C-j>', '<CMD>FloatermHide new<CR>', { silent = true })
    --
    --         vim.cmd([[
    -- 	let g:floaterm_wintype='split'
    -- 	let g:floaterm_position='rightbelow'
    -- 	let g:floaterm_width=1
    -- 	let g:floaterm_height=0.4
    -- 	hi FloatermBorder guibg=none guifg=cyan
    -- 	augroup vimrc_floaterm
    -- 		autocmd!
    -- 		autocmd QuitPre * FloatermKill!
    -- 	augroup END
    -- ]])
    --     end
}
