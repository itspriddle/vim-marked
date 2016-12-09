# marked.vim

Open the current Markdown buffer in [Marked](http://markedapp.com/). Supports
Marked 1 and 2.

**Note**: Since Marked is available only for OS X, this plugin will not be loaded
unless you are on OS X.

## Configuration

By default, this plugin is configred to use Marked 2. If you are still using
Marked version 1, set the following in your `~/.vimrc`:

    let g:marked_app = "Marked"

## Usage

This plugin adds the following commands to Markdown buffers:

    :MarkedOpen[!]          Open the current Markdown buffer in Marked. Call with
                            a bang to prevent Marked from stealing focus from Vim.
                            Documents opened in Marked are tracked and closed
                            automatically when you quit Vim.

    :MarkedQuit             Close the current Markdown buffer in Marked. Quits
                            Marked if there are no other documents open.

    :MarkedToggle[!]        If the current Markdown buffer is already open in
                            Marked, calls :MarkedQuit. If not, calls
                            :MarkedOpen[!].

## License

Same as Vim itself, see `:help license`.
