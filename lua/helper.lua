local helper = {}

-- keymap
for _, mode in pairs({ "n", "v", "i", "s", "o", "c", "t", "x" }) do
	helper[mode .. "map"] = function(lhs, rhs, opts)
		vim.keymap.set(mode, lhs, rhs, opts or { silent = false })
	end
end

helper.usercmd = function(name, func)
	vim.api.nvim_create_user_command(name, func, {})
end

return helper
