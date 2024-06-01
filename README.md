# marked.vim

Open the current Markdown buffer in [Marked 2](https://marked2app.com/).

Adds `:MarkedOpen`, `:MarkedQuit`, `:MarkedToggle`, and `:MarkedPreview`
commands to Markdown buffers, allowing you to quickly open, close, and preview
content in Marked.

**Note**: Since Marked is available only for macOS, this plugin will not be
loaded on other operating systems.

## Usage

This plugin adds the following commands to Markdown buffers (see
`g:marked_filetypes` below to add more FileTypes):

```
:MarkedOpen[!]
```

Open the current Markdown file in Marked. Call with a bang to prevent Marked
from stealing focus from Vim. Documents opened in Marked are tracked and
closed automatically when you quit Vim.

```
:MarkedQuit
```

Close the current Markdown buffer in Marked. Quits Marked if there are no
other documents open.

```
:MarkedToggle[!]
```

If the current Markdown file is already open in Marked, same as
`:MarkedQuit[!]`. If not, same as `:MarkedOpen[!]`.

```
:[range]MarkedPreview[!]
```

Send the current range (defaults to the entire buffer) to Marked as a preview.
Call with a bang to prevent Marked from stealing focus from Vim.

## Configuration

**`g:marked_filetypes`**

Vim FileTypes that can be opened by Marked and will load this plugin. The
default is as follows and can be customized in your `vimrc` if necessary:

```
let g:marked_filetypes = ["markdown", "mkd", "ghmarkdown", "vimwiki"]
```

**`g:marked_app`**

The Marked application name. By default this is "Marked 2". If your app
identifies itself differently, you can set this variable in your `vimrc`:

```
let g:marked_app = "Marked"
```

Note that this plugin requires Marked 2. If you are still using Marked 1, you
can use the 1.0.0 release of this plugin (see below).

## Marked 1

If you are using the older first version of Marked, you can use v1.0.0 of this
plugin from <https://github.com/itspriddle/vim-marked/releases/tag/v1.0.0>.

## License

MIT License - see [`LICENSE`](./LICENSE) in this repo.
