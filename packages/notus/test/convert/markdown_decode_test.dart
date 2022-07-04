import 'package:notus/convert.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/heading_decoder.dart';
import 'package:notus/src/convert/decoder/notus_markdown_decoder.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:test/test.dart';

void main() {
  group('$NotusMarkdownCodec.decode', () {
    test('heading', () {
      var delta = NotusMarkdownDecoder().convert('# hello');
      print(
          'delta = $delta data = ${delta.first.data} attr = ${delta.first.attributes}');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello');
      assert(delta.first.attributes!['heading'] as int == 1);
    });

    test('bold', () {
      var delta = NotusMarkdownDecoder().convert('**hello**');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello');
      assert(delta.first.attributes!['b']);
    });

    test('ul', () {
      var delta = NotusMarkdownDecoder().convert('1. hello\n2. hello');
      print('delta = $delta');
    });
  });
}
