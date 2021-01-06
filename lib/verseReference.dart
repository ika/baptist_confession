
import 'biHelper.dart';
import 'biModel.dart';

BIProvider biProvider = BIProvider();

Future<Map<String, String>> getVerseByReference(String m) async {
  var arr = m.split(';');

  var ref = arr[0]; // Scripture reference

  var b = int.parse(arr[1]); // book
  var c = int.parse(arr[2]); // chapter
  var v = arr[3]; // verse

  var buffer = StringBuffer();
  buffer.clear();

  String delimiter = '|';

  if (v.contains(delimiter)) {
    var ver = v.split(delimiter);
    for (int i = 0; i < ver.length; i++) {
      int x = int.parse(ver[i]);
      List<BIModel> value = await biProvider.getBibleVerse(b, c, x);
      for (var val in value) {
        String l = val.t;
        String w = "$x. $l";
        buffer.writeln(w);
      }
    }
  } else {
    int x = int.parse(v);
    List<BIModel> value = await biProvider.getBibleVerse(b, c, x);
    for (var val in value) {
      String l = val.t;
      String w = "$x. $l";
      buffer.writeln(w);
    }
  }

  Map<String, String> data = {'header': ref, 'contents': buffer.toString()};

  return data;
}