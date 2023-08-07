return {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
        -- You don't need to set any of these options.
        -- IMPORTANT!: this is only a showcase of how you can set default options!
        require("telescope").setup {
            extensions = {
                file_browser = {
                    theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = false,
                    mappings = {
                        ["i"] = {
                        },
                        ["n"] = {
                        },
                    },
                },
            },
        }
        vim.api.nvim_set_keymap(
            "n",
            "<Leader>o",
            ":Telescope file_browser<CR>",
            { noremap = true }
        )
        require("telescope").load_extension "file_browser"
    end
}
