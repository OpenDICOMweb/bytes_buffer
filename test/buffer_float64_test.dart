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
  group('Bytes Float64 Tests', () {
    test('Float64 ReadBuffer', () {
      final bytes = Bytes.empty();
      final wBuf = WriteBuffer(bytes);
      expect(wBuf.bytes == bytes, true);
      expect(wBuf.length == bytes.length, true);
      expect(wBuf.rIndex == 0, true);
      expect(wBuf.wIndex == 0, true);

      var offset = 0;
      for (var i = 1; i < 10; i++) {
        final index = wBuf.wIndex;
        expect(index == offset, true);
        final x = rng.nextFloat64;
        wBuf.writeFloat64(x);
        offset += 8;
        final y = bytes.getFloat64(index);
        expect(x == y, true);
      }
    });

    test('ReadBuffer', () {
      for (var i = 1; i < 10; i++) {
        final vList1 = rng.float64List(1, i);
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

        final vList2 = rBuf.readFloat64List(vList1.length);
        expect(vList2, equals(vList1));
        expect(vList2 != vList1, true);
      }
    });

    test('Float64 Empty Buffer Growing Test', () {
      const startSize = 1;
      const iterations = 1024 * 1;
      final wb0 = WriteBuffer.empty(startSize);
      expect(wb0.rIndex == 0, true);
      expect(wb0.wIndex == 0, true);
      expect(wb0.length == startSize, true);

      var offset = 0;
      for (var i = 0; i <= iterations - 1; i++) {
        final v = rng.nextFloat64;
        wb0.writeFloat64(v);
        print('${wb0.wIndex}: v $v');
        final x = wb0.bytes.getFloat64(offset);
        offset += 8;
        print('$offset: x $x');
        expect(v == x, true);
        expect(offset == wb0.wIndex, true);
      }
      expect(wb0.wIndex == iterations * 8, true);

    });
  });
}
