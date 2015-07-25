# qrencode
Self-contained high-level bindings to [libqrencode](http://fukuchi.org/works/qrencode/). Does not support structured appending at the moment.

## Installation
This repository is a [CHICKEN Scheme](http://call-cc.org/) egg.

It is part of the [CHICKEN egg index](http://wiki.call-cc.org/chicken-projects/egg-index-4.html) and can be installed with `chicken-install qrencode`.

## Requirements
None

## Documentation
    [procedure] (QR-encode-string string [version] [level] [encoding] [case-sensitive?])
    [procedure] (MQR-encode-string string [version] [level] [encoding] [case-sensitive?])
Encodes the given string into a QR code. Returns two values: a u8vector containing the pixel values of the QR code (255 for white and 0 for black) and the number of pixels per row/column of the code. `version` is the desired QR version (between 0 and 40 or 0 and 4 for Micro QR, with 0 being automatic, defaults to 0). `level` is the level of error correction (between 0 and 3, defaults to 2). `encoding` is the encoding type and should be one of `#:numeric`, `#:alpha-numeric`, `#:8-bit`, `#:kanji`, `#:eci`, `#:fnc-first`, or `#:fnc-second` (defaults to `#:8-bit`). `case-sensitive?` is a boolean, defaulting to `#t`.

The `string` must be short enough to be encoded using the given `version`, `level`, `encoding`, and `case-sensitive?`. Otherwise an error will be thrown.

`MQR-encode-string` is the Micro QR version of `QR-encode-string`.

    [procedure] (MQR-encode-string-8bit string [version] [level])
    [procedure] (QR-encode-string-8bit string [version] [level])

Encodes the given string into a QR code in 8 bit mode. Returns two values: a u8vector containing the pixel values of the QR code (255 for white and 0 for black) and the number of pixels per row/column of the code. `version` is the desired QR version (between 0 and 40 or 0 and 4 for Micro QR, with 0 being automatic, defaults to 0). `level` is the level of error correction (between 0 and 3, defaults to 2).

The `string` must be short enough to be encoded using the given `version` and `level`. Otherwise an error will be thrown.

`MQR-encode-string-8bit` is the Micro QR version of `QR-encode-string-8bit`.

    [procedure] (QR-encode-data u8vector [version] [level])
    [procedure] (MQR-encode-data u8vector [version] [level])

Encodes the given u8vector into a QR code. Returns two values: a u8vector containing the pixel values of the QR code (255 for white and 0 for black) and the number of pixels per row/column of the code. `version` is the desired QR version (between 0 and 40 or 0 and 4 for Micro QR, with 0 being automatic, defaults to 0). `level` is the level of error correction (between 0 and 3, defaults to 2).

The `data` must be short enough to be encoded using the given `version` and `level`. Otherwise an error will be thrown.

`MQR-encode-data` is the Micro QR version of `QR-encode-data`.


## Examples
``` scheme
(QR-encode-string "hello world!")
```

You can also try running `./examples/encode-ascii.scm "STRING TO ENCODE"` to create an ASCII QR code.

## Version history
### Version 0.1.0
* Initial release

## Source repository
Source available on [GitHub](https://github.com/AlexCharlton/qrencode).

Bug reports and patches welcome! Bugs can be reported via GitHub or to alex.n.charlton at gmail.

## Author
Alex Charlton

## License
BSD-2-Clause
