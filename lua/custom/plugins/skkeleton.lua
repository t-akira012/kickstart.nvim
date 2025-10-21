return {
  'vim-skk/skkeleton',
  dependencies = {
    'vim-denops/denops.vim',
  },
  config = function()
    -- skkeleton の基本設定
    vim.fn['skkeleton#config'] {
      -- グローバル辞書のパス (適宜変更してください)
      globalDictionaries = {
        '~/.skk/SKK-JISYO.L',
      },
      -- ユーザー辞書のパス (適宜変更してください)
      userDictionary = '~/.skk/skkeleton',
      -- 即時変換モード
      immediatelyCancel = false,
      -- 改行時の確定動作
      keepState = false,
      -- マーカー設定
      markerHenkan = '▽',
      markerHenkanSelect = '▼',
    }

    -- キーマップ設定
    -- Ctrl+j で SKK モードの切り替え
    vim.keymap.set({ 'i', 'c' }, '<C-j>', '<Plug>(skkeleton-toggle)', { silent = true })
  end,
}
