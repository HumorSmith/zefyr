// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'charcode.dart';

String escapeHtml(String html) =>
    const HtmlEscape(HtmlEscapeMode.element).convert(html);

String escapeHtmlAttribute(String text) =>
    const HtmlEscape(HtmlEscapeMode.attribute).convert(text);

/// Escapes the contents of [value], so that it may be used as an HTML
/// attribute.
///
/// Based on http://spec.commonmark.org/0.28/#backslash-escapes.
String escapeAttribute(String value) {
  final result = StringBuffer();
  int ch;
  for (var i = 0; i < value.codeUnits.length; i++) {
    ch = value.codeUnitAt(i);
    if (ch == $backslash) {
      i++;
      if (i == value.codeUnits.length) {
        result.writeCharCode(ch);
        break;
      }
      ch = value.codeUnitAt(i);
      switch (ch) {
        case $quote:
          result.write('&quot;');
          break;
        case $exclamation:
        case $hash:
        case $dollar:
        case $percent:
        case $ampersand:
        case $apostrophe:
        case $lparen:
        case $rparen:
        case $asterisk:
        case $plus:
        case $comma:
        case $dash:
        case $dot:
        case $slash:
        case $colon:
        case $semicolon:
        case $lt:
        case $equal:
        case $gt:
        case $question:
        case $at:
        case $lbracket:
        case $backslash:
        case $rbracket:
        case $caret:
        case $underscore:
        case $backquote:
        case $lbrace:
        case $bar:
        case $rbrace:
        case $tilde:
          result.writeCharCode(ch);
          break;
        default:
          result.write('%5C');
          result.writeCharCode(ch);
      }
    } else if (ch == $quote) {
      result.write('%22');
    } else {
      result.writeCharCode(ch);
    }
  }
  return result.toString();
}

/// One or more whitespace, for compressing.
final _oneOrMoreWhitespacePattern = RegExp('[ \n\r\t]+');

/// "Normalizes" a link label, according to the [CommonMark spec].
///
/// [CommonMark spec] https://spec.commonmark.org/0.29/#link-label
String normalizeLinkLabel(String label) =>
    label.trim().replaceAll(_oneOrMoreWhitespacePattern, ' ').toLowerCase();

extension MatchExtensions on Match {
  /// Returns the whole match String
  String get match => this[0]!;
}
