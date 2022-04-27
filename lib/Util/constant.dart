import 'dart:math';
import 'dart:ui';

const fColor=Color(0xff00c853);

String convertTime(String minutes) {
  if (minutes.length == 1) {
    return "0" + minutes;
  } else {
    return minutes;
  }
}

List<int> makeIDs(double n) {
  var rng = Random();
  List<int> ids = [];
  for (int i = 0; i < n; i++) {
    ids.add(rng.nextInt(100000000));
  }
  return ids;
}
