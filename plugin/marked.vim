" marked.vim
" Author:  Joshua Priddle <jpriddle@me.com>
" URL:     https://github.com/itspriddle/vim-marked
" Version: 2.0.0-beta
" License: Same as Vim itself (see :help license)

" Don't do anything if we're not on macOS.
if &cp || (exists("g:marked_loaded") && g:marked_loaded) || !executable("osascript")
  finish
endif

let g:marked_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

let g:marked_app = get(g:, "marked_app", "Marked 2")
let g:marked_filetypes = get(g:, "marked_filetypes", ["markdown", "mkd", "ghmarkdown", "vimwiki"])

let s:open_documents = []

function! s:AddDocument(path) abort
  if index(s:open_documents, a:path) < 0
    call add(s:open_documents, a:path)
  endif
endfunction

function! s:RemoveDocument(path) abort
  let index = index(s:open_documents, a:path)

  if index >= 0
    unlet s:open_documents[index]
  endif
endfunction

function! s:MarkedOpenURI(background, command, args) abort
  let uri = "x-marked://" . a:command

  if !empty(a:args)
    let uri .= "?" . join(map(items(a:args), 'printf("%s=%s", v:val[0], s:url_encode(v:val[1]))'), "&")
  endif

  execute printf("silent !open %s %s", (a:background ? "-g" : ""), shellescape(uri, 1))
endfunction

function! s:MarkedOpen(background) abort
  let l:filename = expand("%:p")

  call s:AddDocument(l:filename)

  call s:MarkedOpenURI(a:background, "open", {"file": l:filename})
  redraw!
endfunction

function! s:MarkedQuit(force, path) abort
  call s:RemoveDocument(a:path)

  if a:force
    call s:RunApplescript("quit")
  else
    call s:RunApplescript([
      \ 'try',
      \ '  close (first document whose path is equal to (item 1 of argv as string))',
      \ '  if count of documents is equal to 0 then',
      \ '    quit',
      \ '  end if',
      \ 'end try',
      \ ], a:path)
  endif

  redraw!
endfunction

function! s:MarkedPreview(background, line1, line2) abort
  let lines = getline(a:line1, a:line2)

  call s:MarkedOpenURI(a:background, "preview", { "text": join(lines, "\n") })
endfunction

function! s:RunApplescript(raw, ...) abort
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

" From the legend
" https://github.com/tpope/vim-unimpaired/blob/5694455/plugin/unimpaired.vim#L369-L372
function! s:url_encode(str) abort
  return substitute(iconv(a:str, "latin1", "utf-8"), "[^A-Za-z0-9_.~-]", '\="%".printf("%02X", char2nr(submatch(0)))', "g")
endfunction

function! s:MarkedToggle(background_or_force_quit, path) abort
  if index(s:open_documents, a:path) < 0
    call s:MarkedOpen(a:background_or_force_quit)
  else
    call s:MarkedQuit(a:background_or_force_quit, a:path)
  endif
endfunction

function! s:MarkedQuitVimLeave() abort
  if get(g:, "marked_auto_quit", 1)
    for document in s:open_documents
      call s:MarkedQuit(0, document)
    endfor
  endif
endfunction

function! s:RegisterCommands(filetype) abort
  if index(g:marked_filetypes, a:filetype) >= 0
    command! -buffer -bang          MarkedOpen    call s:MarkedOpen(<bang>0)
    command! -buffer -bang          MarkedQuit    call s:MarkedQuit(<bang>0, expand('%:p'))
    command! -buffer -bang          MarkedToggle  call s:MarkedToggle(<bang>0, expand('%:p'))
    command! -buffer -bang -range=% MarkedPreview call s:MarkedPreview(<bang>0, <line1>, <line2>)

    let b:undo_ftplugin = get(b:, "undo_ftplugin", "exe") .
      \ "| delc MarkedOpen | delc MarkedQuit | delc MarkedToggle | delc MarkedPreview"
  endif
endfunction

augroup marked_commands
  autocmd!
  autocmd VimLeavePre * call s:MarkedQuitVimLeave()
  autocmd FileType * call s:RegisterCommands(expand("<amatch>"))
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
