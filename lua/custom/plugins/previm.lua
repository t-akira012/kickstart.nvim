return {
  'previm/previm',
  config = function()
    vim.cmd [[
			let g:previm_open_cmd = "~/bin/_open_browser"
			let g:previm_disable_default_css = 1
			let g:previm_custom_css_path = '~/.config/nvim/assets/previm.css'
			let g:previm_hard_line_break = 1
	    ]]
  end,
}
