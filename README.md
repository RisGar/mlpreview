# mlpreview

- Previews files and directories in the terminal on Unix-likes.

- Can be used as a preview tool for [lf file manager](https://github.com/gokcehan/lf).

- OCaml port of [crpreview](https://github.com/RisGar/crpreview).

## Features

`crpreview` can preview the following formats:

| File type    | Tool                                                                                                  |
| ------------ | ----------------------------------------------------------------------------------------------------- |
| archives[^1] | libarchive                                                                                            |
| images       | [Kitty unicode placeholders](https://sw.kovidgoyal.net/kitty/graphics-protocol/#unicode-placeholders) |
| pdf          | libmupdf                                                                                              |
| videos       | ffmpeg thumbnails                                                                                     |
| text         | bat                                                                                                   |
| directories  | eza                                                                                                   |

[^1]: Supported formats: `tar`, `7-zip`, `zip`, `bzip`, `bzip2`, `gunzip`, `xz`, `zstd`, `lzip`

## Requirements

- If you want images: Terminal emulator that supports the [kitty terminal graphics protocol](https://sw.kovidgoyal.net/kitty/graphics-protocol/)

## Installation

### Nix

Try it out:

```console
nix shell github:RisGar/mlpreview
```

Install it as a profile:

```console
nix profile install github:RisGar/mlpreview
```

Include it in your config:

```nix
inputs = {
  ...
  mlpreview.url = "github:RisGar/mlpreview";
  mlpreview.inputs.nixpkgs.follows = "nixpkgs";
};

...

environment.systemPackages = [
  mlpreview.packages.${pkgs.system}.default
];
```

### Manual

Ensure the following requirements are installed:

- OCaml 5.3
- libarchive
- mupdf
- bat
- eza
- ffmpeg

```console
git clone https://github.com/RisGar/mlpreview
cd mlpreview

opam install . --deps-only
dune build
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
