-- :LeafPreview で現在の Markdown を隣の vsplit に leaf でプレビューする
vim.api.nvim_create_user_command('LeafPreview', function()
  require('leaf_preview').open()
end, { desc = 'leafで現在のMarkdownを隣のvsplitにプレビュー' })
