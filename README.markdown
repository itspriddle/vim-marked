# marked.vim

Vim plugin for [Marked 2](http://marked2app.com), a previewer for Markdown
files.

Adds `:MarkedOpen`, `:MarkedQuit`, `:MarkedToggle`, and `:MarkedPreview`
commands to Markdown buffers, allowing you to quickly open, close, and preview
content in Marked 2.

**Note**: Since Marked is available only for macOS, this plugin will is not
loaded under other operating systems.

## Usage

This plugin adds the following commands to Markdown buffers (see
`g:marked_filetypes` below to add more FileTypes):

```
:MarkedOpen[!]
```

Open the current Markdown file in Marked. Call with a bang to prevent Marked
from stealing focus from Vim.

```
:MarkedQuit[!]
```

Close the Marked document corresponding to the current Markdown file. Call
with a bang to quit Marked completely.

```
:MarkedToggle[!]
```

If the current Markdown file is already open in Marked, same as
`:MarkedQuit[!]`. If not, same as `:MarkedOpen[!]`.

```
:[range]MarkedPreview
```

Send the current range (defaults to the enture buffer) to Marked as a preview.

## Configuration

**`g:marked_filetypes`**

Vim FileTypes that can be opened by Marked and will load this plugin. The
default is as follows and can be customized in your `vimrc` if necessary:

```
let g:marked_filetypes = ["markdown", "mkd", "ghmarkdown", "vimwiki"]
```

**`g:marked_autoquit`**

If true, quit Marked when Vim exits. Default is true. To disable, add the
following to your `vimrc`:

```
let g:marked_autoquit = 0
```

**`MarkedSetup()`**

Vim function to initialize this plugin. Useful for cases where you want to
work with Marked based on a specific filename. For example, to activate the
plugin for `LICENSE` files, add the following to your `vimrc`:

```
autocmd BufNewFile,BufRead LICENSE call MarkedSetup()
```

## License

MIT License - see [`LICENSE`](./LICENSE) in this repo.
