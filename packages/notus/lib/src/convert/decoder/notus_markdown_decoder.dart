import 'dart:convert';

import 'package:markdown/markdown.dart';
import 'package:notus/src/convert/decoder/strong_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

import 'heading_decoder.dart';

class NotusMarkdownDecoder extends Converter<String, Delta> {
  @override
  Delta convert(String input) {
    var nodes = markdownToNodes(input);
    Delta delta = Delta();
    fillNodes(nodes, delta);
    return delta;
  }

  void fillNodes(List<Node> nodes, Delta delta) {
    for (int i = 0; i < nodes.length; i++) {
      var element = nodes[i] as Element;
      print('tag = ${element.tag}  content = ${element.textContent}');
      if (nodes[i] is Heading) {
        HeadingDecoder().fill(delta, nodes[i] as Heading);
      } else if (nodes[i] is Strong) {
        StrongDecoder().fill(delta, nodes[i] as Strong);
      } else if (element.children != null && element.children!.isNotEmpty) {
        fillNodes(element.children!, delta);
      }
    }
  }

  List<Node> markdownToNodes(
    String markdown, {
    Iterable<BlockSyntax> blockSyntaxes = const [],
    Iterable<InlineSyntax> inlineSyntaxes = const [],
    ExtensionSet? extensionSet,
    Resolver? linkResolver,
    Resolver? imageLinkResolver,
    bool inlineOnly = false,
    bool encodeHtml = true,
    bool withDefaultBlockSyntaxes = true,
    bool withDefaultInlineSyntaxes = true,
  }) {
    var document = Document(
      blockSyntaxes: blockSyntaxes,
      inlineSyntaxes: inlineSyntaxes,
      extensionSet: extensionSet,
      linkResolver: linkResolver,
      imageLinkResolver: imageLinkResolver,
      encodeHtml: encodeHtml,
      withDefaultBlockSyntaxes: withDefaultBlockSyntaxes,
      withDefaultInlineSyntaxes: withDefaultInlineSyntaxes,
    );
    if (inlineOnly) return document.parseInline(markdown);
    // Replace windows line endings with unix line endings, and split.
    var lines = markdown.replaceAll('\r\n', '\n').split('\n');
    return document.parseLines(lines);
  }
}
