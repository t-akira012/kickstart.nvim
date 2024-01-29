return {
    'skanehira/denops-translate.vim',
    dependencies = {
        'vim-denops/denops.vim'
    },
    config = function()
        vim.keymap.set('n', 'te', '<CMD>Translate<CR>')
        vim.keymap.set('n', 'tj', '<CMD>Translate!<CR>')
    end
}
