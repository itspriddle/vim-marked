" marked.vim
" Author:  Joshua Priddle <jpriddle@me.com>
" URL:     https://github.com/itspriddle/vim-marked
" Version: 1.0.0
" License: Same as Vim itself (see :help license)

" Don't do anything if we're not on OS X.
if &cp || (exists("g:marked_loaded") && g:marked_loaded) || !has('unix') || system('uname -s') != "Darwin\n"
  finish
endif

let g:marked_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

let g:marked_app = get(g:, "marked_app", "Marked 2")
let g:marked_filetypes = get(g:, "marked_filetypes", ["markdown", "mkd", "ghmarkdown", "vimwiki"])

let s:open_documents = []

function! s:AddDocument(path)
  if index(s:open_documents, a:path) < 0
    call add(s:open_documents, a:path)
  endif
endfunction

function! s:RemoveDocument(path)
  let index = index(s:open_documents, a:path)

  if index >= 0
    unlet s:open_documents[index]
  endif
endfunction

function! s:OpenMarked(background)
  let l:filename = expand("%:p")

  call s:AddDocument(l:filename)

  silent exe "!open -a '".g:marked_app."' ".(a:background ? '-g' : '')." '".l:filename."'"
  redraw!
endfunction

function! s:QuitMarked(path)
  call s:RemoveDocument(a:path)

  call s:applescript([
    \ 'try',
    \ '  close (first document whose path is equal to (item 1 of argv as string))',
    \ '  if count of documents is equal to 0 then',
    \ '    quit',
    \ '  end if',
    \ 'end try',
    \ ], a:path)

  redraw!
endfunction

function! s:applescript(raw, ...) abort
  let app = get(g:, "marked_app", "Marked 2")

  let lines = [
    \ 'on run argv',
    \ '  if application "' . app . '" is running then',
    \ '    tell application "' . app . '"',
    \ ]

  let lines += type(a:raw) == type([]) ? a:raw : [a:raw]

  let lines += [
    \ '    end tell',
    \ '  end if',
    \ 'end run',
    \ ]

  let applescript = join(map(lines, "'-e ' . shellescape(v:val, 1)"), " ")

  let args = join(map(copy(a:000), "shellescape(v:val, 1)"), " ")

  silent let output = system(printf("osascript %s %s", applescript, args))

  return trim(output)
endfunction

function! s:ToggleMarked(background, path)
  if index(s:open_documents, a:path) < 0
    call s:OpenMarked(a:background)
  else
    call s:QuitMarked(a:path)
  endif
endfunction

function! s:QuitAll()
  for document in s:open_documents
    call s:QuitMarked(document)
  endfor
endfunction

function! s:RegisterCommands(filetype) abort
  if index(g:marked_filetypes, a:filetype) >= 0
    command! -buffer -bang MarkedOpen   call s:OpenMarked(<bang>0)
    command! -buffer       MarkedQuit   call s:QuitMarked(expand('%:p'))
    command! -buffer -bang MarkedToggle call s:ToggleMarked(<bang>0, expand('%:p'))

    let b:undo_ftplugin = get(b:, "undo_ftplugin", "exe") .
      \ "| delc MarkedOpen | delc MarkedQuit | delc MarkedToggle"
  endif
endfunction

augroup marked_commands
  autocmd!
  autocmd VimLeavePre * call s:QuitAll()
  autocmd FileType * call s:RegisterCommands(expand("<amatch>"))
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
