return {
    'stevearc/conform.nvim',
    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                javascript = { "deno_fmt" },
                typescript = { "deno_fmt" },
                sql = { "sqlfmt" },
                sh = { "shfmt" },
                go = { "gofmt" },
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 500,
            },
        })
    end
}
