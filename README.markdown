# marked.vim

Open the current Markdown buffer in [Marked](http://markedapp.com/). Supports
Marked 1 and 2.

## Usage

This plugin adds the following commands to Markdown buffers:

    :MarkedOpen[!] Open the current Markdown buffer in Marked.app.
                   Call with a bang to prevent Marked.app from stealing
                   focus from Vim.

    :MarkedQuit    Close the current Markdown buffer in Marked.app.
                   Quit Marked.app if no other documents are open.

If you run `:MarkedOpen`, the document in Marked will be automatically closed
when Vim exists, and Marked will quit if no other documents are open.

## Configuration

By default, this plugin is configred to use Marked 2. If you are still using
Marked 1, set the following in your `~/.vimrc`:

    let g:marked_app = "Marked"

## License

Same as Vim itself, see `:help license`.
