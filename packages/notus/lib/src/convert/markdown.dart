// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:ffi';

import 'package:markdown/markdown.dart' as markdown;
import 'package:notus/convert.dart';
import 'package:notus/notus.dart';
import 'package:quill_delta/quill_delta.dart';

import 'decoder/notus_markdown_decoder.dart';

class NotusMarkdownCodec extends Codec<Delta, String> {
  const NotusMarkdownCodec();

  @override
  Converter<String, Delta> get decoder => NotusMarkdownDecoder();

  @override
  Converter<Delta, String> get encoder => _NotusMarkdownEncoder();
}

class _NotusMarkdownEncoder extends Converter<Delta, String> {
  static const kBold = '**';
  static const kItalic = '_';
  static const kUnderline = '<u>';
  static const kUnchecked = '- [ ] ';
  static const kChecked = '- [x] ';
  static const kStrikethrough = '~~';

  static final kSimpleBlocks = <NotusAttribute, String>{
    NotusAttribute.bq: '> ',
    NotusAttribute.ul: '* ',
    NotusAttribute.ol: '1. ',
  };

  @override
  String convert(Delta input) {
    final iterator = DeltaIterator(input);
    final buffer = StringBuffer();
    final lineBuffer = StringBuffer();
    NotusAttribute<String>? currentBlockStyle;
    var currentInlineStyle = NotusStyle();
    var currentBlockLines = [];

    void _handleBlock(NotusAttribute<String>? blockStyle) {
      if (currentBlockLines.isEmpty) {
        return; // Empty block
      }

      if (blockStyle == null) {
        buffer.write(currentBlockLines.join('\n\n'));
        buffer.writeln();
      } else if (blockStyle == NotusAttribute.code) {
        _writeAttribute(buffer, blockStyle);
        buffer.write(currentBlockLines.join('\n'));
        _writeAttribute(buffer, blockStyle, close: true);
        buffer.writeln();
      } else if (blockStyle == NotusAttribute.cl) {
        _writeAttribute(buffer, blockStyle);
        buffer.write(currentBlockLines.join('\n'));
      } else {
        for (var line in currentBlockLines) {
          _writeBlockTag(buffer, blockStyle);
          buffer.write(line);
          buffer.writeln();
        }
      }
      buffer.writeln();
    }

    void _handleSpan(String text, Map<String, dynamic>? attributes) {
      final style = NotusStyle.fromJson(attributes);
      currentInlineStyle =
          _writeInline(lineBuffer, text, style, currentInlineStyle);
    }

    void _handleLine(Map<String, dynamic>? attributes) {
      final style = NotusStyle.fromJson(attributes);
      final lineBlock = style.get(NotusAttribute.block);
      if (lineBlock == currentBlockStyle) {
        currentBlockLines.add(_writeLine(lineBuffer.toString(), style));
      } else {
        _handleBlock(currentBlockStyle);
        currentBlockLines.clear();
        currentBlockLines.add(_writeLine(lineBuffer.toString(), style));

        currentBlockStyle = lineBlock;
      }
      lineBuffer.clear();
    }

    while (iterator.hasNext) {
      final op = iterator.next();
      final opText = op.data is String ? op.data as String : '';
      final lf = opText.indexOf('\n');
      if (lf == -1) {
        _handleSpan(op.data as String, op.attributes);
      } else {
        var span = StringBuffer();
        for (var i = 0; i < opText.length; i++) {
          if (opText.codeUnitAt(i) == 0x0A) {
            if (span.isNotEmpty) {
              // Write the span if it's not empty.
              _handleSpan(span.toString(), op.attributes);
            }
            // Close any open inline styles.
            _handleSpan('', null);
            _handleLine(op.attributes);
            span.clear();
          } else {
            span.writeCharCode(opText.codeUnitAt(i));
          }
        }
        // Remaining span
        if (span.isNotEmpty) {
          _handleSpan(span.toString(), op.attributes);
        }
      }
    }
    _handleBlock(currentBlockStyle); // Close the last block
    return buffer.toString();
  }

  String _writeLine(String text, NotusStyle style) {
    var buffer = StringBuffer();
    if (style.containsSame(NotusAttribute.cl)) {
      var attrMap = style.toJson();
      var checked = attrMap!['checked'];
      if (checked == null || !checked) {
        buffer.write(kUnchecked);
      } else {
        buffer.write(kChecked);
      }
      buffer.write(text);
      return buffer.toString();
    }

    if (style.contains(NotusAttribute.heading)) {
      _writeAttribute(buffer, style.get<int>(NotusAttribute.heading));
    }

    // Write the text itself
    buffer.write(text);
    return buffer.toString();
  }

  String _trimRight(StringBuffer buffer) {
    var text = buffer.toString();
    if (!text.endsWith(' ')) return '';
    final result = text.trimRight();
    buffer.clear();
    buffer.write(result);
    return ' ' * (text.length - result.length);
  }

  NotusStyle _writeInline(StringBuffer buffer, String text, NotusStyle style,
      NotusStyle currentStyle) {
    // First close any current styles if needed
    for (var value in currentStyle.values) {
      if (value.scope == NotusAttributeScope.line) continue;
      if (style.containsSame(value)) continue;
      final padding = _trimRight(buffer);
      _writeAttribute(buffer, value, close: true);
      if (padding.isNotEmpty) buffer.write(padding);
    }
    // Now open any new styles.
    for (var value in style.values) {
      if (value.scope == NotusAttributeScope.line) continue;
      if (currentStyle.containsSame(value)) continue;
      final originalText = text;
      text = text.trimLeft();
      final padding = ' ' * (originalText.length - text.length);
      if (padding.isNotEmpty) buffer.write(padding);
      _writeAttribute(buffer, value);
    }
    // Write the text itself
    buffer.write(text);
    return style;
  }

  void _writeAttribute(StringBuffer buffer, NotusAttribute? attribute,
      {bool close = false}) {
    if (attribute == NotusAttribute.bold) {
      _writeBoldTag(buffer);
    } else if (attribute == NotusAttribute.italic) {
      _writeItalicTag(buffer);
    } else if (attribute?.key == NotusAttribute.link.key) {
      _writeLinkTag(buffer, attribute as NotusAttribute<String>, close: close);
    } else if (attribute?.key == NotusAttribute.heading.key) {
      _writeHeadingTag(buffer, attribute as NotusAttribute<int>);
    }else if(attribute?.key == NotusAttribute.underline.key){
      _writeUnderlineTag(buffer, close: close);
    }else if(attribute?.key == NotusAttribute.strikethrough.key){
      _writeStrikeThroughTag(buffer);
    }
    else if (attribute?.key == NotusAttribute.block.key) {
      if(attribute!= null && attribute.value == NotusAttribute.cl.value){
        return;
      }
      var notusStyle = NotusStyle.fromJson(attribute?.toJson());
      _writeBlockTag(buffer, attribute as NotusAttribute<String>, close: close);
    } else {
      throw ArgumentError('Cannot handle $attribute');
    }
  }

  void _writeBoldTag(StringBuffer buffer) {
    buffer.write(kBold);
  }

  void _writeItalicTag(StringBuffer buffer) {
    buffer.write(kItalic);
  }

  void _writeStrikeThroughTag(StringBuffer buffer) {
    buffer.write(kStrikethrough);
  }

  void _writeLinkTag(StringBuffer buffer, NotusAttribute<String> link,
      {bool close = false}) {
    if (close) {
      buffer.write('](${link.value})');
    } else {
      buffer.write('[');
    }
  }

  void _writeUnderlineTag(StringBuffer buffer,
      {bool close = false}) {
    if (close) {
      buffer.write('</u>');
    } else {
      buffer.write(kUnderline);
    }
  }

  void _writeHeadingTag(StringBuffer buffer, NotusAttribute<int> heading) {
    var level = heading.value!;
    buffer.write('#' * level + ' ');
  }

  void _writeBlockTag(StringBuffer buffer, NotusAttribute<String> block,
      {bool close = false}) {
    if (block == NotusAttribute.code) {
      if (close) {
        buffer.write('\n```');
      } else {
        buffer.write('```\n');
      }
    } else {
      if (close) return; // no close tag needed for simple blocks.

      final tag = kSimpleBlocks[block];
      buffer.write(tag);
    }
  }
}
