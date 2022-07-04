import 'package:markdown/markdown.dart';

class Heading extends Element {
  int level;
  Heading(
    String tag,
    List<Node>? children,
    this.level,
  ) : super(tag, children);
}
