# mlpreview

Previews files and directories in the [lf file manager](https://github.com/gokcehan/lf) on macOS.

OCaml port of [crpreview](https://github.com/RisGar/crpreview).

## Features

`crpreview` can preview the following formats:

| File type    | Tool         |
| ------------ | ------------ |
| archives[^1] | `libarchive` |
| images       | `chafa`      |
| pdf          | `quick look` |
| videos       | `quick look` |
| text         | `bat`        |
| directories  | `eza`        |

[^1]: Supported formats: `tar`, `7-zip`, `zip`, `bzip`, `bzip2`, `gunzip`, `xz`, `zstd`, `lzip`

## Requirements

- Reasonable version of macOS
- Terminal emulator that supports the [kitty terminal graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/)
- OCaml 5.2
- libarchive via homebrew
- chafa
- bat
- eza

All of the above mentioned preview tools which you want to use.

## Installation

```console
$ dune build --profile release
```

## Usage

Add the following lines to your `lfrc`:

```conf
set previewer /path/to/mlpreview/bin/mlpreview
map i $ /path/to/mlpreview/bin/mlpreview $f | less -R
```

Make sure to install the required decompressors for `libarchive` to list archive contents.

## Contributing

1. Fork it (<https://github.com/RisGar/crpreview/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
