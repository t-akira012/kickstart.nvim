return {
  'wincent/vim-clipper',
  config = function()
    vim.cmd [[
      let g:ClipperAddress="~/.clipper.sock"
      let g:ClipperPort=0
      let g:ClipperLoaded=1
    ]]
  end
}
