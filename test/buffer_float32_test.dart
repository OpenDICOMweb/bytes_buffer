//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes/bytes.dart';
import 'package:bytes_buffer/bytes_buffer.dart';
import 'package:rng/rng.dart';
import 'package:test/test.dart';

void main() {
  final rng = RNG();

  group('Bytes Float32 Tests', () {
    test('ReadBuffer', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rng.float32List(1, i);
        final bytes1 = Bytes.typedDataView(vList1);
        final rBuf = ReadBuffer(bytes1);

        expect(rBuf.bytes.buf.buffer == bytes1.buffer, true);
        expect(rBuf.bytes == bytes1, true);
        expect(rBuf.length == bytes1.length, true);
        expect(
            rBuf.bytes.buf.buffer.lengthInBytes == bytes1.buffer.lengthInBytes,
            true);
        expect(rBuf.rIndex == 0, true);
        expect(rBuf.wIndex == bytes1.length, true);
      }
    });
  });
}
