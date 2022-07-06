import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import '../base_decoder.dart';

class StrongDecoder extends BaseDecoder<Element> {
  @override
  void fill(Delta delta, Element input) {
    print('StrongDecoder fill');
    delta.insert(input.textContent, NotusAttribute.bold.toJson());
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'strong';
  }
}
