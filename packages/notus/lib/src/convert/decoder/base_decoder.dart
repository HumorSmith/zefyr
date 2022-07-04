import 'package:markdown/markdown.dart';
import 'package:quill_delta/quill_delta.dart';

abstract class BaseDecoder<T>{
  void fill(Delta delta,T input);
}