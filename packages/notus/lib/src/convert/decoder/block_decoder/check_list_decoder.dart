import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class CheckListDecoder extends BaseDecoder<Element> {
  @override
  void fill(Delta delta, Element input) {
    var children = input.children;
    delta.insert(input.textContent);
    for (int i = 0; i < children!.length; i++) {
      var child = children[i];
      if (child is! Element) {
        continue;
      }
      var attr = child.attributes;
      if (attr['checked'] != null && attr['checked'] == 'true') {
        var clMap = NotusAttribute.cl.toJson();
        clMap['checked'] = true;
        delta.insert('\n', clMap);
      } else {
        delta.insert('\n', NotusAttribute.cl.toJson());
      }
    }
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'li' && input.attributes['class'] == 'task-list-item';
  }
}
