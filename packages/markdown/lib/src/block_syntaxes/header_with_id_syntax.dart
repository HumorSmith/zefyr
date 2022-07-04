// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:markdown/src/ast_nodes/heading.dart';

import '../ast.dart';
import '../block_parser.dart';
import 'block_syntax.dart';
import 'header_syntax.dart';

/// Parses atx-style headers, and adds generated IDs to the generated elements.
class HeaderWithIdSyntax extends HeaderSyntax {
  const HeaderWithIdSyntax();

  @override
  Node parse(BlockParser parser) {
    final heading = super.parse(parser) as Heading;
    heading.generatedId = BlockSyntax.generateAnchorHash(heading);
    return heading;
  }
}
