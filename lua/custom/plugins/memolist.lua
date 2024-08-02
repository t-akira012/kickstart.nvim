return {
  'glidenote/memolist.vim',
  config = function()
    vim.cmd [[
        nnoremap mn  :MemoNew<CR>
        let g:memolist_path = expand('$HOME') .."/docs/doc/mmmm"
        " suffix type (default markdown)
        let g:memolist_memo_suffix = "md"
        " date format (default %Y-%m-%d %H:%M)
        let g:memolist_memo_date = "%Y-%m-%d_%H:%M"
      ]]
  end,
}
