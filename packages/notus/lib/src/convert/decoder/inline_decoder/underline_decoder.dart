import 'package:markdown/src/ast.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class UnderlineDecoder extends BaseDecoder<Element> {
  @override
  void fill(Delta delta, Element input) {
    delta.insert(input.tag,NotusAttribute.underline.toJson());
  }

  @override
  bool tryMatch(Element input) {
    throw input.tag == 'em';
  }
}
