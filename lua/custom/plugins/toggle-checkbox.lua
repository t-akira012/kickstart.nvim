return {
	'opdavies/toggle-checkbox.nvim',
	config = function()
		vim.keymap.set("n", "tt", ":lua require('toggle-checkbox').toggle()<CR>")
	end
}
