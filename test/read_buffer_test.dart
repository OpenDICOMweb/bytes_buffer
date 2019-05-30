//  Copyright (c) 2016, 2017, 2018,
//  Poplar Hill Informatics and the American College of Radiology
//  All rights reserved.
//  Use of this source code is governed by the open source license
//  that can be found in the odw/LICENSE file.
//  Primary Author: Jim Philbin <jfphilbin@gmail.edu>
//  See the AUTHORS file for other contributors.
//
import 'dart:convert' as cvt;
import 'package:bytes/bytes.dart';
import 'package:bytes_buffer/bytes_buffer.dart';
import 'package:rng/rng.dart';
import 'package:test/test.dart';

void main() {
  final rng = RNG();
  group('Bytes Tests', () {
    test('ReadBuffer', () {
      final vList = ['1q221', 'sadaq223'];
      final bytes0 = Bytes.fromStringList(vList);
      final rBuf = ReadBuffer(bytes0);

      expect(rBuf.bytes.buf.buffer == bytes0.buffer, true);
      expect(rBuf.bytes == bytes0, true);
      expect(rBuf.length == bytes0.length, true);
      expect(rBuf.bytes.buf.buffer.lengthInBytes == bytes0.buffer.lengthInBytes,
          true);
      expect(rBuf.rIndex == 0, true);
      expect(rBuf.wIndex == bytes0.length, true);
    });

    test('ReadBuffer', () {
      final vList = rng.uint8List(1, 10);
      final bytes = Bytes.typedDataView(vList);
      final rBuf0 = ReadBuffer(bytes);

      expect(rBuf0.rIndex == bytes.offset, true);
      expect(rBuf0.wIndex == bytes.length, true);
      expect(
          rBuf0.bytes.buf.buffer.asUint8List().elementAt(0) == vList[0], true);
      expect(rBuf0.offset == bytes.offset, true);
      expect(rBuf0.bytes == bytes, true);

      final rBuf1 = ReadBuffer.fromList(vList);
      print('readBuffer1: $rBuf1');

      expect(rBuf1.rIndex == bytes.offset, true);
      expect(rBuf1.wIndex == bytes.length, true);
      expect(
          rBuf1.bytes.buf.buffer.asUint8List().elementAt(0) == vList[0], true);
      expect(rBuf1.offset == bytes.offset, true);
      expect(rBuf1.bytes == bytes, true);
    });

    test('ReadBuffer.from', () {
      final vList = rng.uint8List(1, 10);
      final bytes = Bytes.fromList(vList);
      final rb = ReadBuffer(bytes);
      print('rb: $rb');

      expect(rb.rIndex == bytes.offset, true);
      expect(rb.wIndex == bytes.length, true);
      expect(rb.bytes.buf.buffer.asUint8List().elementAt(0) == vList[0], true);
      expect(rb.offset == bytes.offset, true);
      expect(rb.bytes == bytes, true);

      final from0 = ReadBuffer.from(rb);
      print('ReadBuffer.from: $from0');

      expect(from0.rIndex == bytes.offset, true);
      expect(from0.wIndex == bytes.length, true);
      expect(
          from0.bytes.buf.buffer.asUint8List().elementAt(0) == vList[0], true);
      expect(from0.offset == bytes.offset, true);
      expect(from0.bytes == bytes, true);
    });

    test('ReadBuffer readString', () {
      for (var i = 1; i < 10; i++) {
        final s0 = rng.asciiString(i);
        final bytes = Bytes.fromList(s0.codeUnits);
        final rb = ReadBuffer(bytes);
        print('rb: $rb');

        final readAscii0 = rb.readString(s0.length);
        print('readAscii: $readAscii0');
        final s1 = cvt.ascii.decode(bytes.buf, allowInvalid: true);
        expect(readAscii0 == s1, true);
      }
    });

    test('ReadBuffer readString', () {
      for (var i = 1; i < 10; i++) {
        final s0 = rng.asciiString(i);
        final bytes = Bytes.fromString(s0);
        final rb = ReadBuffer(bytes);
        print('rb: $rb');

        final readString0 = rb.readString(s0.length);
        print('readString: $readString0');
        expect(readString0 == cvt.utf8.decode(bytes), true);
      }
    });

    test('ReadBuffer readUint8List', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint8List(1, i);
        final bytes = Bytes.fromList(vList);
        final rb = ReadBuffer(bytes);
        print('rb: $rb');

        final v = rb.readUint8List(vList.length);
        print('readString: $v');
        expect(v, equals(vList));
      }
    });

    test('ReadBuffer readUint16List', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint16List(1, i);
        final bytes = Bytes.typedDataView(vList);
        final rb = ReadBuffer(bytes);
        print('rb: $rb');

        final v = rb.readUint16List(vList.length);
        print('readUtf16: $v');
        expect(v, equals(vList));
      }
    });

    test('ReadBuffer readUint32List', () {
      for (var i = 1; i < 10; i++) {
        final vList = rng.uint32List(1, i);
        print('vList $vList');
        final bytes = Bytes.typedDataView(vList);
        print('Bytes $bytes');
        final rb = ReadBuffer(bytes);
        print('rb: $rb');
        final v = rb.readUint32List(vList.length);
        print('readUint32: $v');
        expect(v, equals(vList));
      }
    });
  });
}
