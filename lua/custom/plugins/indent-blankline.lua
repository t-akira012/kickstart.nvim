return {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    config = function()
        local config = require("ibl.config").default_config
        config.indent.tab_char = config.indent.char
        config.scope.enabled = false
        require("ibl").setup()
    end,
}
