import 'package:markdown/src/ast.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:notus/src/convert/decoder/block_decoder/check_list_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class ListDecoder extends BaseDecoder<Element> {
  @override
  void fill(Delta delta, Element input) {
    var children = input.children;
    if (children == null) {
      return;
    }
    for (int i = 0; i < children.length; i++) {
      var child = children[i];
      if (input.tag == 'ol') {
        delta.insert(child.textContent);
        delta.insert('\n', NotusAttribute.ol.toJson());
      } else if (input.tag == 'ul') {
        var checkBoxDecoder = CheckListDecoder();
        //li tag
        if (child is Element && checkBoxDecoder.tryMatch(child)) {
          checkBoxDecoder.fill(delta, child);
          continue;
        }
        delta.insert(child.textContent);
        delta.insert('\n', NotusAttribute.ul.toJson());
      }
    }
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'ol' || input.tag == 'ul';
  }
}
