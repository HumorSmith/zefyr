import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import '../base_decoder.dart';

class HeadingDecoder extends BaseDecoder<Element> {
  List<NotusAttribute<int>> levels = [
    NotusAttribute.h1,
    NotusAttribute.h2,
    NotusAttribute.h3
  ];

  List<String> heads = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'];

  @override
  void fill(Delta delta, Element input) {
    var level = input.tag.substring(1, 2);
    print('HeadingDecoder fill level = $level');
    delta.insert(input.textContent,null);
    delta.insert('\n', levels[int.tryParse(level)!-1].toJson());
  }

  @override
  bool tryMatch(Element input) {
    String? head = heads.firstWhereOrNull((it) => it == input.tag);
    return head != null;
  }
}
