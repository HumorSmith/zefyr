import 'package:markdown/markdown.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class TextDecoder extends BaseDecoder<Text> {
  @override
  void fill(Delta delta, input) {
    delta.insert(input.textContent);
  }

  @override
  bool tryMatch(Text input) {
    return false;
  }
}
