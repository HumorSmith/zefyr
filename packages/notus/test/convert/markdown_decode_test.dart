import 'package:notus/convert.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/inline_decoder/heading_decoder.dart';
import 'package:notus/src/convert/decoder/notus_markdown_decoder.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:test/test.dart';

void main() {
  group('$NotusMarkdownCodec.decode', () {
    test('heading', () {
      var delta = NotusMarkdownDecoder().convert('# hello');
      print('delta = ${delta.toJson().toString()}');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello');
      assert(delta.last.attributes!['heading'] as int == 1);
    });

    test('bold', () {
      var delta = NotusMarkdownDecoder().convert('**hello**');
      print('delta = $delta end');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello');
      assert(delta.first.attributes!['b']);
    });

    test('italic', () {
      var delta = NotusMarkdownDecoder().convert('*hello*');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello');
      assert(delta.first.attributes!['i']);
      print('italic delta = $delta');
    });

    test('strike', () {
      var delta = NotusMarkdownDecoder().convert('~~hello~~');
      print('strike delta = $delta');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello');
      assert(delta.first.attributes!['s']);
    });

    test('code', () {
      var delta = NotusMarkdownDecoder().convert('```\nhello world\n```');
      print('code delta = $delta');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'hello world\n');
    });

    test('ol', () {
      var delta = NotusMarkdownDecoder().convert('1. java\n2. cpp\n3. python');
      print('delta = $delta');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'java');
      var second = delta.toList()[1];
      assert(second.isInsert);
      assert(second.attributes!['block'] == 'ol');
      var third = delta.toList()[2];
      assert(third.isInsert);
      assert(third.data == 'cpp');
    });

    test('ul', () {
      var delta = NotusMarkdownDecoder().convert('- java\n- cpp\n- python');
      print('delta = $delta');
      assert(delta.first.isInsert);
      assert(delta.first.data == 'java');
      var second = delta.toList()[1];
      assert(second.isInsert);
      assert(second.attributes!['block'] == 'ul');
      var third = delta.toList()[2];
      assert(third.isInsert);
      assert(third.data == 'cpp');
    });

    // test('underline',(){
    //   var delta =
    //   NotusMarkdownDecoder().convert('++hello++');
    //   assert(delta.first.isInsert);
    //   assert(delta.first.data == 'hello');
    //   assert(delta.first.attributes!['i']);
    //   print('italic delta = $delta');
    // });

    test('ol', () {
      var delta = NotusMarkdownDecoder().convert('1. hello');
      print('delta = $delta');
    });
  });
}
