import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import 'base_decoder.dart';

class StrongDecoder extends BaseDecoder<Strong> {
  @override
  void fill(Delta delta, Strong input) {
    print('StrongDecoder fill');
    delta.insert(input.textContent, NotusAttribute.bold.toJson());
  }
}
