import 'package:markdown/src/ast.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class ListDecoder extends BaseDecoder<Element> {
  @override
  void fill(Delta delta, Element input) {
    var children = input.children;
    if (children == null) {
      return;
    }
    for (int i = 0; i < children.length; i++) {
      delta.insert(children[i].textContent);
      if (input.tag == 'ol') {
        delta.insert(
            '${children[i].textContent}\n', NotusAttribute.ol.toJson());
      } else {
        delta.insert(
            '${children[i].textContent}\n', NotusAttribute.ul.toJson());
      }
    }
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'ol' || input.tag == 'ul';
  }
}
