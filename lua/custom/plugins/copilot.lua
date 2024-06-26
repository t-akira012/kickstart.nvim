return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        if os.getenv('USER') == 't-akira012' then
            vim.keymap.set('n', '<F2>', '<CMD>Copilot disable<CR>', { silent = true })
            require("copilot").setup({
                panel = {
                    auto_refresh = true,
                },
                suggestion = {
                    enabled = false,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<c-a>",
                        accept_word = false,
                        accept_line = false,
                        dismiss = "<c-e>",
                        next = "<c-j>",
                        prev = "<c-k>",
                    },
                },
            })
        end
    end,
}
