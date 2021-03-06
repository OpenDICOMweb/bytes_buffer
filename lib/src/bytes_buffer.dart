//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:typed_data';

import 'package:bytes/bytes.dart';

/// The base class for Buffer
abstract class BytesBuffer {
  /// The underlying [Bytes] for the buffer.
  Bytes get bytes;
  set bytes(Bytes bytes) => throw UnsupportedError('Unsupported Setter');
  int get _rIndex;
  set _rIndex(int n);
  int get _wIndex;

  /// The offset of _this_ in the underlying [ByteBuffer].
  int get offset => bytes.offset;

  /// The start of _this_ in the underlying [ByteBuffer].
  int get start => bytes.offset;

  /// The length of the [bytes].
  int get length => bytes.length;

  /// The index of the _end_ of _this_. _Note_: [end] is not a legal index.
  int get end => start + bytes.length;

  /// The read index into the underlying bytes.
  int get readIndex => _rIndex;

  /// Pseudonym for [readIndex].
  int get rIndex => _rIndex;

  /// Pseudonym for set [readIndex].
  set rIndex(int n) => _rIndex = n;

  /// The write index into the underlying bytes.
  int get writeIndex => _rIndex;

  /// Pseudonym for [writeIndex].
  int get wIndex => _wIndex;

  /// Returns _true_ if the _this_ is not readable.
  bool get isNotReadable => !isReadable;

  /// Returns _true_ if the _this_ is not writable.
  bool get isNotWritable => !isWritable;

  // ****  External Getters

  /// The maximum [length] of _this_.
  int get limit => bytes.length;

  /// The endianness of _this_.
  Endian get endian => bytes.endian;

  /// The number of readable bytes in [bytes].
  int get readRemaining;

  /// Returns _true_ if [readRemaining] >= 0.
  bool get isReadable;

  /// The current number of writable bytes in [bytes].
  int get writeRemaining;

  /// Returns _true_ if [writeRemaining] >= 0.
  bool get isWritable;

  /// The maximum number of writable bytes in [bytes].
  int get writeRemainingMax;

  // ****  End of External Getters

  /// Returns _true_ if _this_ has [n] readable bytes.
  bool rHasRemaining(int n) => (readIndex + n) <= writeIndex;

  /// Returns _true_ if _this_ has [n] writable bytes.
  bool wHasRemaining(int n) => (writeIndex + n) <= end;

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

  /// Return a [ByteData] view of _this_ of [length], starting at [start].
  /// If [length] is _null_ it defaults to [length].
  ByteData asByteData([int start, int length]) =>
      bytes.asByteData(start ?? readIndex, length ?? writeIndex);

  /// Return a [Uint8List] view of _this_ of [length], starting at [start].
  /// If [length] is _null_ it defaults to [length].
  Uint8List asUint8List([int start, int length]) =>
      bytes.asUint8List(start ?? readIndex, length ?? writeIndex);

  /// Prints a warning message when reading.
  void rWarn(Object msg) => print('** Warning: $msg @$readIndex');

  /// Prints a Error message when reading.
  void rError(Object msg) => throw Exception('**** Error: $msg @$writeIndex');

  /// Prints a warning message when writing.
  void wWarn(Object msg) => print('** Warning: $msg @$readIndex');

  /// Prints a Error message when writing.
  void wError(Object msg) => throw Exception('**** Error: $msg @$writeIndex');
}
