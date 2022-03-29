import 'dart:io';

import 'package:console/console.dart';
import 'package:dotenv/dotenv.dart';

DotEnv loadEnvFromFile(String file) {
  checkFileExists(file);

  return DotEnv()..load([file]);
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

void checkFileExists(String file) {
  if (!File(file).existsSync()) {
    Console.setTextColor(Color.RED.id);
    Console.write("$file not found\n");
    exit(-1);
  }
}

void checkDirectoryExists(String file) {
  if (!Directory(file).existsSync()) {
    Console.setTextColor(Color.RED.id);
    Console.write("$file not found\n");
    exit(-1);
  }
}
