// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:notus/notus.dart';
import 'package:test/test.dart';

NotusDocument dartconfDoc() {
  return NotusDocument()..insert(0, 'DartConf\nLos Angeles');
}

final ul = NotusAttribute.ul.toJson();
final h1 = NotusAttribute.h1.toJson();

void main() {
  final heuristics = NotusHeuristics(
    formatRules: NotusHeuristics.fallback.formatRules,
    insertRules: NotusHeuristics.fallback.insertRules,
    deleteRules: NotusHeuristics.fallback.deleteRules,
  );
  final doc = dartconfDoc();

  group('$NotusHeuristics', () {
    test('ensures heuristics are applied', () {


      // expect(() {
      //   print('applyInsertRules = $applyInsertRules');
      // }, throwsStateError);

      expect(() {
        heuristics.applyDeleteRules(doc, 0, 1);
      }, throwsStateError);

      expect(() {
        heuristics.applyFormatRules(doc, 0, 1, NotusAttribute.bold);
      }, throwsStateError);
    });
  },);
  test('test bold', () {
    var boldText = '**haha**';
    var applyInsertRules = heuristics.applyInsertRules(doc, doc.length+boldText.length, boldText);
    print('applyInsertRules = $applyInsertRules');
  });
}
