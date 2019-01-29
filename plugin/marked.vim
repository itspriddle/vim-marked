" marked.vim
" Author:  Joshua Priddle <jpriddle@me.com>
" URL:     https://github.com/itspriddle/vim-marked
" Version: 2.0.0-beta
" License: Same as Vim itself (see :help license)

if &cp || (exists("g:marked_loaded") && g:marked_loaded)
  finish
endif

let g:marked_loaded = 1
let s:save_cpo = &cpo
set cpo&vim

function! s:warn(message) abort
  echohl WarningMsg
  echo "marked.vim " . a:message
  echohl None
endfunction

if !has("macunix") || !executable("osascript")
  function! MarkedSetup()
    call s:warn("skipped initialization on non-macOS operating system")
  endfunction

  let &cpo = s:save_cpo
  unlet s:save_cpo

  finish
endif

let s:opened_marked = 0

let g:marked_filetypes = get(g:, "marked_filetypes", ["markdown", "mkd", "ghmarkdown", "vimwiki"])

function! s:marked_open_uri(background, command, args) abort
  let uri = "x-marked://" . a:command

  if !empty(a:args)
    let uri .= "?" . join(map(items(a:args), 'printf("%s=%s", v:val[0], s:url_encode(v:val[1]))'), "&")
  endif

  execute printf("silent !open %s %s", (a:background ? "-g" : ""), shellescape(uri, 1))

  let s:opened_marked = 1
endfunction

function! s:MarkedOpen(background, path) abort
  call s:marked_open_uri(a:background, "open", { "file": a:path })
endfunction

function! s:MarkedQuit(force, path) abort
  if a:force
    call s:applescript("quit")

    let s:opened_marked = 0
  else
    call s:applescript([
      \ 'try',
      \ '  close (first document whose path is equal to (item 1 of argv as string))',
      \ 'end try',
      \ ], a:path)
  endif
endfunction

function! s:MarkedQuitVimLeave() abort
  if get(g:, "marked_autoquit", 1) && s:opened_marked
    call s:MarkedQuit(1, "")
  endif
endfunction

function! s:MarkedToggle(background_or_force_quit, path) abort
  if s:is_document_open(a:path)
    call s:MarkedQuit(a:background_or_force_quit, a:path)
  else
    call s:MarkedOpen(a:background_or_force_quit, a:path)
  endif
endfunction

function! s:MarkedPreview(background, line1, line2) abort
  let text = join(getline(a:line1, a:line2), "\n")

  call s:marked_open_uri(a:background, "preview", { "text": text })
endfunction

function! s:is_document_open(path) abort
  let result = s:applescript('if (path of every document) contains (item 1 of argv as string) then "1"', a:path)

  return result == "1"
endfunction

function! s:FileTypeInit(filetype) abort
  if index(g:marked_filetypes, a:filetype) >= 0
    call MarkedSetup()

    let b:undo_ftplugin = get(b:, "undo_ftplugin", "exe") .
      \ "| delc MarkedOpen | delc MarkedQuit | delc MarkedToggle | delc MarkedPreview"
  endif
endfunction

function! MarkedSetup() abort
  command! -buffer -bang          MarkedOpen    call s:MarkedOpen(<bang>0, expand("%:p"))
  command! -buffer -bang          MarkedQuit    call s:MarkedQuit(<bang>0, expand("%:p"))
  command! -buffer -bang          MarkedToggle  call s:MarkedToggle(<bang>0, expand("%:p"))
  command! -buffer -bang -range=% MarkedPreview call s:MarkedPreview(<bang>0, <line1>, <line2>)
endfunction

" From the legend
" https://github.com/tpope/vim-unimpaired/blob/5694455/plugin/unimpaired.vim#L369-L372
function! s:url_encode(str) abort
  return substitute(iconv(a:str, "latin1", "utf-8"), "[^A-Za-z0-9_.~-]", '\="%".printf("%02X", char2nr(submatch(0)))', "g")
endfunction

function! s:applescript(raw, ...) abort
  let lines = [
    \ 'on run argv',
    \ '  if application "Marked 2" is running then',
    \ '    tell application "Marked 2"',
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

augroup marked_commands
  autocmd!
  autocmd FileType    * call s:FileTypeInit(expand("<amatch>"))
  autocmd VimLeavePre * call s:MarkedQuitVimLeave()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
