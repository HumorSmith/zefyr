import 'dart:convert';

import 'package:markdown/markdown.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:notus/src/convert/decoder/block_decoder/code_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/italic_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/strike_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/strong_decoder.dart';
import 'package:notus/src/convert/decoder/inline_decoder/text_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

import 'inline_decoder/heading_decoder.dart';

class NotusMarkdownDecoder extends Converter<String, Delta> {
  List<BaseDecoder<Element>> decoders = [
    StrongDecoder(),
    HeadingDecoder(),
    ItalicDecoder(),
    StrikeDecoder(),
    CodeDecoder()
  ];

  @override
  Delta convert(String input) {
    var nodes = markdownToNodes(input,extensionSet: ExtensionSet.gitHubWeb);
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
      bool isMatch = false;
      var element = nodes[i] as Element;
      print('tag = ${element.tag}  content = ${element.textContent}');
      for (var decoder in decoders) {
        if (decoder.tryMatch(element)) {
          decoder.fill(delta, element);
          isMatch = true;
          continue;
        }
      }
      if(isMatch){
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
