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

#### :MarkedOpen[!]

Open the current Markdown file in Marked. Call with a bang to prevent Marked
from stealing focus from Vim. Documents opened in Marked are tracked and
closed automatically when you quit Vim.

#### :MarkedQuit[!]

Close the current Markdown buffer in Marked. Quits Marked if there are no
other documents open. Call with a bang to quit Marked completely.

#### :MarkedToggle[!]

If the current Markdown file is already open in Marked, same as
`:MarkedQuit[!]`. If not, same as `:MarkedOpen[!]`.

#### :[range]MarkedPreview[!]

Send the current range (defaults to the entire buffer) to Marked as a preview.
Call with a bang to prevent Marked from stealing focus from Vim.

## Configuration

**`g:marked_filetypes`**

Vim FileTypes that can be opened by Marked and will load this plugin. The
default is as follows and can be customized in your `vimrc` if necessary:

```vim
let g:marked_filetypes = ["markdown", "mkd", "ghmarkdown", "vimwiki"]
```

**`g:marked_auto_quit`**

If true, quit Marked when Vim exits. Default is true. To disable, add the
following to your `vimrc`:

```vim
let g:marked_auto_quit = 0
```

**`g:marked_app`**

The Marked application name. By default this is "Marked 2". If your version of
Marked 2 doesn't open with `open -a "Marked 2"`, you can specify a different
name or path to the application.

```vim
let g:marked_app = "/Applications/Setapp/Marked 2.app"
```

Note that this plugin requires Marked 2. If you are still using Marked 1, you
can use the 1.0.0 release of this plugin (see [below](#marked-1)).

## Installation

Use your favorite plugin manager to install this plugin. For example, using
[vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'itspriddle/vim-marked'
```

Or using vim's built-in package manager:

```sh
mkdir -p ~/.vim/pack/itspriddle/start
cd ~/.vim/pack/itspriddle/start
git clone https://github.com/itspriddle/vim-marked.git
vim -u NONE -c "helptags vim-marked/doc" -c q
```

### Marked 1

If you are using the older first version of Marked, you can use v1.0.0 of this
plugin from <https://github.com/itspriddle/vim-marked/releases/tag/v1.0.0>.

For vim-plug:

```vim
Plug 'itspriddle/vim-marked', { 'tag': 'v1.0.0' }
```

Or using vim's built-in package manager:

```sh
mkdir -p ~/.vim/pack/itspriddle/start
cd ~/.vim/pack/itspriddle/start
git clone --branch v1.0.0 https://github.com/itspriddle/vim-marked.git
vim -u NONE -c "helptags vim-marked/doc" -c q
```

## License

MIT License - see [`LICENSE`](./LICENSE) in this repo.
