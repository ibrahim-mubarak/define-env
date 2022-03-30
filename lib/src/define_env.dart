import 'dart:async';

import 'package:define_env/src/loader/loader.dart';
import 'package:dotenv/dotenv.dart';

Future<DotEnv> loadEnv(String file) async {
  if (file == '-') {
    return StdinLoader().load();
  }

  return FileLoader(file).load();
}

String convertEnvToDartDefineString(DotEnv env) {
  StringBuffer buffer = StringBuffer();

  // ignore: invalid_use_of_visible_for_testing_member
  env.map.forEach((key, value) {
    if (value.isEmpty) return;

    if (value.contains(" ")) {
      value = '"$value"';
    }

    buffer.write("--dart-define=$key=$value ");
  });
  var string = buffer.toString();
  var finalStringToPrintAndCopy = string.substring(0, string.length - 1);
  return finalStringToPrintAndCopy;
}
