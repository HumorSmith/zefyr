import 'dart:convert';

import 'package:markdown/markdown.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:notus/src/convert/decoder/block_decoder/code_decoder.dart';
import 'package:notus/src/convert/decoder/block_decoder/list_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/italic_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/strike_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/strong_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/text_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

import 'inline_decoder/heading_decoder.dart';

class NotusMarkdownDecoder extends Converter<String, Delta> {
  List<BaseDecoder<Element>> inlineDecoders = [
    StrongDecoder(),
    HeadingDecoder(),
    ItalicDecoder(),
    StrikeDecoder(),
  ];

  List<BaseDecoder<Element>> blockDecoders = [CodeDecoder(), ListDecoder()];

  @override
  Delta convert(String input) {
    var nodes = markdownToNodes(input, extensionSet: ExtensionSet.gitHubWeb);
    Delta delta = Delta();
    fillNodes(nodes, delta);
    return delta;
  }

  void fillNodes(List<Node> nodes, Delta delta) {
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i] is Text) {
        TextDecoder().fill(delta, nodes[i] as Text);
        continue;
      }
      var element = nodes[i] as Element;
      print('tag = ${element.tag}  content = ${element.textContent}');
      bool isMatch = false;

      for (var blockDecoder in blockDecoders) {
        if (blockDecoder.tryMatch(element)) {
          blockDecoder.fill(delta, element);
          isMatch = true;
        }
      }

      if (isMatch) {
        continue;
      }

      for (var inlineDecoder in inlineDecoders) {
        if (inlineDecoder.tryMatch(element)) {
          inlineDecoder.fill(delta, element);
          isMatch = true;
          continue;
        }
      }
      if (isMatch) {
        continue;
      }
      if (element.children != null && element.children!.isNotEmpty) {
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
    final document = Document(
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
    final lines = markdown.replaceAll('\r\n', '\n').split('\n');

    final nodes = document.parseLines(lines);

    return nodes;
  }
}
