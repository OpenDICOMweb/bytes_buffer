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
import 'package:bytes_buffer/src/write_buffer_mixin.dart';

/// A writable [ByteBuffer].
class WriteBuffer with WriteBufferMixin {
  @override
  GrowableBytes bytes;
  final int rIndex;
  int _wIndex;

  /// Creates an empty WriteBuffer.
  WriteBuffer(
      [int length = kDefaultLength,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = 1,
        _wIndex = 0,
        bytes = GrowableBytes(length, endian, limit);

  /// Creates a [WriteBuffer] from another [WriteBuffer].
  WriteBuffer.from(WriteBuffer wb,
      [int offset = 0,
      int length,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset,
        _wIndex = offset,
        bytes = GrowableBytes.from(wb.bytes, offset, length, endian, limit);

  /// Creates a WriteBuffer from a [GrowableBytes].
  WriteBuffer.fromBytes(this.bytes, this.rIndex, this._wIndex);

  /// Creates a [WriteBuffer] that uses a [TypedData] view of [td].
  WriteBuffer.typedDataView(TypedData td,
      [int offset = -1,
      int lengthInBytes,
      Endian endian = Endian.little,
      int limit = kDefaultLimit])
      : rIndex = offset,
        _wIndex = lengthInBytes ?? td.lengthInBytes,
        bytes = GrowableBytes.typedDataView(td, offset ?? 0,
            lengthInBytes ?? td.lengthInBytes, endian ?? Endian.little, limit);

  /// Returns the current write index.
  int get wIndex => _wIndex;
  set wIndex(int n) {
    if (wIndex < rIndex || wIndex >= bytes.length)
      throw RangeError.range(wIndex, rIndex, bytes.length);
    _wIndex = n;
  }

  /// Returns the Endianness of _this_.
  Endian get endian => bytes.endian;

  /// Return a view of _this_ of [length], starting at [start]. If [length]
  /// is _null_ it defaults to [length].
  Bytes view([int start = 0, int length]) =>
      bytes.asBytes(start, length ?? length);
}