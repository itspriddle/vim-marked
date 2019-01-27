# marked.vim

Open the current Markdown buffer in [Marked 2](http://marked2app.com/).

**Note**: Since Marked is available only for OS X, this plugin will not be loaded
unless you are on OS X.

## Configuration

If you need to enable the plugin for custom Vim FileTypes:

    let g:marked_filetypes = ["markdown", "mkd", "ghmarkdown", "vimwiki"]

## Usage

This plugin adds the following commands to Markdown buffers:

    :MarkedOpen[!]          Open the current Markdown buffer in Marked. Call with
                            a bang to prevent Marked from stealing focus from Vim.

    :MarkedQuit[!]          Close the Marked document corresponding to the
                            current buffer. Quits Marked if there are no othe
                            documents open. Call with a bang to immediately
                            quit Marked (and any open documents).

    :MarkedToggle[!]        If the current Markdown buffer is already open in
                            Marked, calls :MarkedQuit[!]. If not, calls
                            :MarkedOpen[!].

    :MarkedPreview          Send the current range (defaults to the entire
                            buffer) to Marked as a preview.

## License

Same as Vim itself, see `:help license`.
