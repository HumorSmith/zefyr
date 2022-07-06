import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class CodeDecoder extends BaseDecoder<Element>{
  @override
  void fill(Delta delta, Element input) {
    delta.insert(input.textContent,NotusAttribute.code.toJson());
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'code';
  }

}