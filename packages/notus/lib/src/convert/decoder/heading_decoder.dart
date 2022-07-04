import 'dart:convert';

import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import 'base_decoder.dart';

class HeadingDecoder extends BaseDecoder<Heading>{
  List<NotusAttribute<int>> levels = [
    NotusAttribute.h1,
    NotusAttribute.h2,
    NotusAttribute.h3
  ];

  @override
  void fill(Delta delta,Heading input){
    delta.insert(input.textContent,levels[input.level-1].toJson());
  }
}
