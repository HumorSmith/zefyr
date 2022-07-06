import 'package:markdown/src/ast.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class ItalicDecoder extends BaseDecoder<Element> {
  @override
  void fill(Delta delta, Element input) {
    delta.insert(input.textContent, NotusAttribute.italic.toJson());
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'em';
  }
}
