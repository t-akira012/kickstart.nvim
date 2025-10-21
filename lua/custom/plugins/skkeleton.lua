return {
  'vim-skk/skkeleton',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    -- skkeleton 基本設定
    vim.fn['skkeleton#config'] {
      globalDictionaries = {
        '~/.skk/SKK-JISYO.L',
      },
      userDictionary = '~/.skk/skkeleton',
      immediatelyCancel = false,
      keepState = false,
      markerHenkan = '▽',
      markerHenkanSelect = '▼',
    }

    -- SKK モード切り替え
    vim.keymap.set({ 'i', 'c' }, '<C-j>', '<Plug>(skkeleton-toggle)', { silent = true })

    -- 候補移動キー
    vim.keymap.set({ 'i', 'c' }, '<C-n>', '<Plug>(skkeleton-next-candidate)', { silent = true })
    vim.keymap.set({ 'i', 'c' }, '<C-p>', '<Plug>(skkeleton-prev-candidate)', { silent = true })
  end,
}
