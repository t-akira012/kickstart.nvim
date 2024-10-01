setlocal comments=nb:>,
      \  comments+=b:-\ [\ ],b:-\ [x],b:-
      \  comments+=b:*,b:-,b:+,b:1.
setlocal formatoptions-=c formatoptions+=jro

setlocal nolist

" 監視対象のディレクトリを変数として定義（init.vimなどで設定可能）
if !exists('g:markdown_autoread_dirs')
  let g:markdown_autoread_dirs = [
    \ expand('$HOME/docs'),
    \ expand('$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents')
    \ ]
endif

" このバッファに対してのみ autoread を有効にする
setlocal autoread


" 現在のファイルが監視対象ディレクトリ内にあるかチェック
function! s:is_watched_file()
  let l:file_path = expand('%:p')
  for l:dir in g:markdown_autoread_dirs
    if l:file_path =~# '^' . escape(l:dir, '~.\$^*[]()') 
      return 1
    endif
  endfor
  return 0
endfunction

" ファイル差分を検知
function! CheckAndReloadFile()
  if s:is_watched_file()
    checktime
  endif
endfunction

autocmd FocusGained,BufEnter,CursorHold,CursorHoldI <buffer> call CheckAndReloadFile()
