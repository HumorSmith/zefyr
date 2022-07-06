import 'package:markdown/markdown.dart';
import 'package:quill_delta/quill_delta.dart';

abstract class BaseDecoder<T extends Node> {
  void fill(Delta delta, T input);

  bool tryMatch(T input);
}
