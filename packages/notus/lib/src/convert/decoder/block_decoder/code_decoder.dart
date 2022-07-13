import 'package:markdown/markdown.dart';
import 'package:notus/notus.dart';
import 'package:notus/src/convert/decoder/base_decoder.dart';
import 'package:quill_delta/quill_delta.dart';

class CodeDecoder extends BaseDecoder<Element>{
  @override
  void fill(Delta delta, Element input) {
    int len = input.textContent.length;
    String isLineSep = input.textContent.substring(len-1,len);
    if(isLineSep == '\n'){
      delta.insert(input.textContent.substring(0,len-1));
    }else{
      delta.insert(input.textContent);
    }
    delta.insert('\n',NotusAttribute.code.toJson());
  }

  @override
  bool tryMatch(Element input) {
    return input.tag == 'code';
  }

}