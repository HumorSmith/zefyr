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
      assert(delta.first.data == 'hello world');
    });

    test('ol', () {
      var delta = NotusMarkdownDecoder().convert('1. java\n2. cpp\n3. python');
      print('delta = $delta');
      var first = delta.first;
      assert(first.isInsert);
      assert(first.data == 'java');
      var second = delta.toList()[1];
      assert(second.isInsert);
      assert(second.data == '\n');
      assert(second.attributes!['block'] == 'ol');

      first = delta.toList()[2];
      assert(first.isInsert);
      assert(first.data == 'cpp');
      second = delta.toList()[3];
      assert(second.data == '\n');
      assert(second.attributes!['block'] == 'ol');
    });

    test('underline', () {
      var delta = NotusMarkdownDecoder().convert('<u>下划线文本</u>');
      print('delta = $delta');
    });

    test('ul', () {
      var delta = NotusMarkdownDecoder().convert('- java\n- cpp\n');
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

    test('ol', () {
      var delta = NotusMarkdownDecoder().convert('1. hello\n2.java');
      print('delta = $delta');
    });

    test('check', () {
      var delta = NotusMarkdownDecoder().convert('- [ ] data\n- [x] data');
      print('check delta = $delta');
    });

    test('not block test', () {
      String markdown = '# 一级\n**加粗**\n~~删除~~';
      var delta = NotusMarkdownDecoder().convert(markdown);
      assert(delta.first.isInsert);
      assert(delta.first.data == '一级');
    });

    test('code', () {
      String markdown = '```java\nhello world\n```';
      var delta = NotusMarkdownDecoder().convert(markdown);
      print('code delta = $delta');
    });

    test('test wrong', () {
      String markdown = r'''1. o1
1. o2
1. o3
* u1
* u2
* u3
- [ ]  c1
- [ ]  c2
- [ ]  c3
```
java is number 1
```''';
      var delta = NotusMarkdownDecoder().convert(markdown);
      print('delta = $delta');
      print(delta.toJson().toString());
    });
  });
}
