//  Copyright (c) 208, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'package:bytes_buffer/debug/test_utils.dart';
import 'package:rng/rng.dart';
import 'package:test/test.dart';

void main() {
  final rng = RNG();

  group('ReadBuffer Basic Tests', () {
    test('ReadBuffer LE', () {
      final vList0 = rng.int8List();
      final rBuf = getReadBufferLE(vList0);
      final bytes = rBuf.bytes;
      expect(rBuf.bytes == bytes, true);
      expect(rBuf.buffer == bytes.buffer, true);
      expect(rBuf.length == bytes.length, true);
      expect(rBuf.rIndex == 0, true);
      expect(rBuf.wIndex == bytes.length, true);
    });

    test('ReadBuffer BE', () {
      final vList0 = rng.int8List();
      final rBuf = getReadBufferBE(vList0);
      final bytes = rBuf.bytes;
      expect(rBuf.bytes == bytes, true);
      expect(rBuf.buffer == bytes.buffer, true);
      expect(rBuf.length == bytes.length, true);
      expect(rBuf.rIndex == 0, true);
      expect(rBuf.wIndex == bytes.length, true);
    });
  });

  group('WriteBuffer Basic Tests', () {
    test('WriteBuffer LE', () {
      final vList0 = rng.int8List();
      final wBuf = getWriteBufferLE(vList0.length);
      final bytes = wBuf.bytes;
      expect(wBuf.bytes == bytes, true);
      expect(wBuf.buffer == bytes.buffer, true);
      expect(wBuf.length == bytes.length, true);
      expect(wBuf.rIndex == 0, true);
      expect(wBuf.wIndex == 0, true);
    });

    test('WriteBuffer BE', () {
      final vList0 = rng.int8List();
      final wBuf = getWriteBufferBE(vList0.length);
      final bytes = wBuf.bytes;
      expect(wBuf.bytes == bytes, true);
      expect(wBuf.buffer == bytes.buffer, true);
      expect(wBuf.length == bytes.length, true);
      expect(wBuf.rIndex == 0, true);
      expect(wBuf.wIndex == 0, true);
    });

    test('WriteBuffer LE Buffer Growing Test', () {
      const startSize = 1;
      const iterations = 1024 * 1;
      final wb0 = getWriteBuffer(startSize, 'LE');
      expect(wb0.rIndex == 0, true);
      expect(wb0.wIndex == 0, true);
      expect(wb0.length == startSize, true);

      var offset = 0;
      for (var i = 0; i <= iterations - 1; i++) {
        final v = rng.nextFloat32;
        wb0.writeFloat32(v);
        offset += 4;
        expect(wb0.wIndex == offset, true);
      }
      expect(wb0.wIndex == iterations * 4, true);
    });

    test('WriteBuffer BE Buffer Growing Test', () {
      const startSize = 1;
      const endSize = 1024 * 1024;
      final wb0 = getWriteBuffer(startSize, 'BE');
      expect(wb0.rIndex == 0, true);
      expect(wb0.wIndex == 0, true);
      expect(wb0.length == startSize, true);

      var offset = 0;
      for (var i = 0; i <= endSize - 1; i++) {
       // final v = rng.nextFloat32;
        const v = 255;
        wb0.writeUint8(v);
        offset++;
        expect(wb0.wIndex == offset, true);
      }
      expect(wb0.wIndex == endSize, true);
    });
  });
}
