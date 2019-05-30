//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes/bytes.dart';


/// The base class for BytesBuffer]s.
abstract class BytesBufferBase {
  /// The underlying [Bytes] for the buffer.
  Bytes get bytes;

  /// The current read index into _this_.
  int get rIndex;

  /// The current write index into _this_.
  int get wIndex;

  /// The offset of _this_ in the underlying [ByteBuffer].
  int get offset => bytes.offset;

  /// The length of [bytes].
  int get length => bytes.length;

  /// Returns the Endianness of _this_.
  Endian get endian => bytes.endian;

  /// The underlying [ByteBuffer].
  ByteBuffer get buffer => bytes.buf.buffer;

  /// Returns _true_ if there are bytes that can be read.
  bool get isReadable => wIndex > 0;

  /// Returns _true_ if _this_ has [n] readable bytes.
  bool rHasRemaining(int n) => (rIndex + n) <= wIndex;

  /// Returns the number of readable bytes in _this_.
  int get readRemaining => wIndex - rIndex;

  /// Returns _true_ if there are bytes that can be written.
  bool get isWritable => writeRemaining > 0;

  /// Returns _true_ if _this_ has [n] writable bytes.
  bool wHasRemaining(int n) => (wIndex + n) <= length;
  /// Returns the number of readable bytes in _this_.

  /// Returns the number of writable bytes in _this_.
  int get writeRemaining => bytes.length - wIndex;

  ///  int get remaining => writeRemaining;
  int get writeRemainingMax => bytes.length - wIndex;

  /// Returns _true_ if there are no bytes left to read.
  bool get isEmpty => readRemaining <= 0;

  /// Returns _true_ if there are bytes left to read.
  bool get isNotEmpty => !isEmpty;

  /// The read index into the underlying bytes.
  int get readIndex => rIndex;

  /// The write index into the underlying bytes.
  int get writeIndex => wIndex;

  /// Returns _true_ if the _this_ is not readable.
  bool get isNotReadable => !isReadable;

  /// Returns _true_ if the _this_ is not writable.
  bool get isNotWritable => !isWritable;

  /// Returns a _view_ of [bytes] containing the bytes from [start] inclusive
  /// to [end] exclusive. If [end] is omitted, the [length] of _this_ is used.
  /// An error occurs if [start] is outside the range 0 .. [length],
  /// or if [end] is outside the range [start] .. [length].
  /// [length].
  Bytes sublist([int start = 0, int end]) =>
      Bytes.from(bytes, start, (end ?? length) - start);

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [length].
  Bytes view([int start = 0, int length]) =>
      bytes.asBytes(start, length ?? length);

/* Urgent remove after all tests written and working
  /// Returns a [Uint8List] that is a view of _this_
  /// from [offset] with [length].
  Uint8List uint8View([int offset = 0, int length]) {
    length ??= bytes.length;
    final off = bytes.offset + offset;
    assert(off >= 0 && off <= length);
    assert(off + length >= off && (off + length) <= length);
    return bytes.asUint8List(off, length ?? length - off);
  }
*/

  /// Return a [Uint8List] view of _this_ of [length], starting at [offset].
  /// If [length] is _null_ it defaults to [length].
  Uint8List asUint8List([int offset, int length]) =>
      bytes.asUint8List(offset, length);

  /// Return a [ByteData] view of _this_ of [length], starting at [start].
  /// If [length] is _null_ it defaults to [length].
  ByteData asByteData([int start, int length]) =>
      bytes.asByteData(start ?? rIndex, length ?? wIndex);

  /// Prints a warning message when reading.
  void rWarn(Object msg) => print('** Warning: $msg @$rIndex');

  /// Prints a Error message when reading.
  void rError(Object msg) => throw Exception('**** Error: $msg @$wIndex');

  /// Prints a warning message when writing.
  void wWarn(Object msg) => print('** Warning: $msg @$rIndex');

  /// Prints a Error message when writing.
  void wError(Object msg) => throw Exception('**** Error: $msg @$wIndex');
}
