import 'dart:io';

import 'package:console/console.dart';
import 'package:dotenv/dotenv.dart' as dotEnv;

void loadEnvFromFile(String file) {
  checkFileExists(file);
  dotEnv.load(file);
  Platform.environment.forEach((key, value) {
    if (dotEnv.env.remove(key) == null) return;
    Console.setTextColor(Color.YELLOW.id);
    Console.write(
        "The field '$key' in the .env file was skipped because already present in 'Platform.environment' map.");
  });
}

String convertEnvMapToDartDefineString(Map<String, String> envMap) {
  StringBuffer buffer = StringBuffer();
  envMap.forEach((key, value) {
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
