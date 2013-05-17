" marked.vim
" Author:  Joshua Priddle <jpriddle@me.com>
" URL:     https://github.com/itspriddle/vim-marked
" Version: 0.1.0
" License: Same as Vim itself (see :help license)

if &cp || exists("g:marked_loaded") && g:marked_loaded
  finish
endif
let g:marked_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

function s:OpenMarked()
  silent exe "!open -a Marked.app '%:p'"
  redraw!
endfunction

function s:QuitMarked()
  let pid = system('ps ax | grep "[M]arked" | awk "{print \$1}"')
  if ! empty(pid)
    silent exe "!kill -HUP ".pid
    redraw!
  endif
endfunction

if has('autocmd')
  augroup marked_autoclose
    autocmd!
    autocmd VimLeave * :call <SID>QuitMarked()
    autocmd Filetype markdown command! -buffer MarkedOpen :call s:OpenMarked()
    autocmd FileType markdown command! -buffer MarkedQuit :call s:QuitMarked()
  augroup END
endif

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
