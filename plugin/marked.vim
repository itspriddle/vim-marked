" marked.vim
" Author:  Joshua Priddle <jpriddle@me.com>
" URL:     https://github.com/itspriddle/vim-marked
" Version: 0.5.0
" License: Same as Vim itself (see :help license)

" Don't do anything if we're not on OS X.
if !has('unix') || system('uname -s') != "Darwin\n"
  finish
endif

if &cp || exists("g:marked_loaded") && g:marked_loaded
  finish
endif
let g:marked_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

let g:marked_app = get(g:, "marked_app", "Marked 2")

let s:open_documents = []

function s:OpenMarked(background)
  let l:filename = expand("%:p")

  if index(s:open_documents, l:filename) < 0
    call add(s:open_documents, l:filename)
  endif

  silent exe "!open -a '".g:marked_app."' ".(a:background ? '-g' : '')." '".l:filename."'"
  redraw!
endfunction

function s:QuitMarked(path)
  let cmd  = " -e 'try'"
  let cmd .= " -e 'if application \"".g:marked_app."\" is running then'"
  let cmd .= " -e 'tell application \"".g:marked_app."\"'"
  let cmd .= " -e 'close (first document whose path is equal to \"".a:path."\")'"
  let cmd .= " -e 'if count of documents is equal to 0 then'"
  let cmd .= " -e 'quit'"
  let cmd .= " -e 'end if'"
  let cmd .= " -e 'end tell'"
  let cmd .= " -e 'end if'"
  let cmd .= " -e 'end try'"

  silent exe "!osascript ".cmd
  redraw!
endfunction

function s:ToggleMarked(background, path)
  if index(s:open_documents, a:path) < 0
    call s:OpenMarked(a:background)
  else
    call s:QuitMarked(a:path)
  endif
endfunction

function s:QuitAll()
  for document in s:open_documents
    call s:QuitMarked(document)
  endfor
endfunction

augroup marked_commands
  autocmd!
  autocmd FileType markdown,mkd,ghmarkdown command! -buffer -bang MarkedOpen :call s:OpenMarked(<bang>0)
  autocmd FileType markdown,mkd,ghmarkdown command! -buffer MarkedQuit :call s:QuitMarked(expand('%:p'))
  autocmd FileType markdown,mkd,ghmarkdown command! -buffer -bang MarkedToggle :call s:ToggleMarked(<bang>0, expand('%:p'))
  autocmd VimLeavePre * call s:QuitAll()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
