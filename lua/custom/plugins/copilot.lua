return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      panel = {
        auto_refresh = true,
      },
      suggestion = {
        enabled = true,
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
  end,
}
