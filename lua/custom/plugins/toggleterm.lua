return {
    "akinsho/toggleterm.nvim",
    config = function()
        require("toggleterm").setup({
            open_mapping = [[<c-h>]],
            size = function(term)
                if term.direction == "horizontal" then
                    return 33
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            autochdir = true,
            auto_scroll = false,
        })
    end
}
